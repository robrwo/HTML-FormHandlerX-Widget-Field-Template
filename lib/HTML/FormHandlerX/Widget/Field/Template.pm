package HTML::FormHandlerX::Widget::Field::Template;

use v5.10;

use Moose::Role;

use Cache::LRU;
use Digest::MD5 qw/ md5_hex /;
use Sereal::Encoder;
use Types::Standard -types;

use namespace::autoclean;

our $VERSION = '0.001';

# ABSTRACT: render fields using templates

=head1 NAME

HTML::FormHandlerX::Widget::Field::Template - render fields using templates

=head1 SYNOPSIS

In a form class:

  has_field foo => (
    widget        => 'Template',
    template_args => sub {
      my ($field, $args) = @_;
      ...
    },
  );

  sub template_renderer {
    my ( $self, $field ) = @_;

    return sub {
        my ($args) = @_;

        my $field = $args->{field};

        ...

    };
  }

=head1 DESCRIPTION

This is an L<HTML::FormHandler> widget that allows you to use a
template for rendering forms instead of Perl methods.

=cut

has template_renderer => (
    is      => 'ro',
    isa     => CodeRef,
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        $self->form->template_renderer;
    },
);

has template_args => (
    is        => 'rw',
    predicate => 'has_template_args',
    isa       => CodeRef,
);

has template_cache => (
    is      => 'ro',
    isa     => Int,
    lazy    => 1,
    default => 0,
);

sub render {
    my ( $self, $result ) = @_;
    $result ||= $self->result;
    die "No result for form field '"
      . $self->full_name
      . "'. Field may be inactive."
      unless $result;

    my $form = $self->form;

    my %args;

    if ( my $method = $form->can('template_args') ) {
        $form->$method( $self, \%args );
    }

    if ( $self->has_template_args ) {
        $self->template_args->( $self, \%args );
    }

    if ( my $method = $form->can( 'template_args_' . $self->name ) ) {
        $form->$method( \%args );
    }

    if ( my $size = $self->template_cache ) {

        state $cache = Cache::LRU->new( size => $size );
        state $enc   = Sereal::Encoder->new( { no_shared_hashkeys => 1 } );

        my $data = {
            %args,
            field => {
                full_name => $self->full_name,
                value     => $self->value,
            }
        };

        my $sig = md5_hex( $enc->encode($data) );

        return $cache->get($sig)
          // $cache->set(
            $sig => $self->template_renderer->( { %args, field => $self } ) );

    }

    return $self->template_renderer->( { %args, field => $self } );
}

1;
