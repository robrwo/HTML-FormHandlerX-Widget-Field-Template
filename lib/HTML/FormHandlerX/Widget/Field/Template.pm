package HTML::FormHandlerX::Widget::Field::Template;

use v5.10;

use strict;
use warnings;

our $VERSION = 'v0.1.0';

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

use Moose::Role;

use Types::Standard -types;

use namespace::autoclean;

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

    return $self->template_renderer->( { %args, field => $self } );
}

1;

=head1 SEE ALSO

=over

=item *

L<HTML::FormHandler>

=item *

L<Template>

=back

=head1 append:AUTHOR

The initial development of this module was sponsored by Science Photo
Library L<https://www.sciencephoto.com>.

=cut
