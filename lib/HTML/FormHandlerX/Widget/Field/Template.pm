package HTML::FormHandlerX::Widget::Field::Template;

use Moose::Role;

use PerlX::Maybe;
use Template;
use Types::Standard -types;

use namespace::autoclean;

has template_renderer => (
    is      => 'ro',
    isa     => CodeRef,
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        $self->form->template_renderer($self);
    },
);

sub render {
    my ( $self, $result ) = @_;
    $result ||= $self->result;
    die "No result for form field '"
      . $self->full_name
      . "'. Field may be inactive."
      unless $result;

    my $field = $result->field_def;
    my $form  = $field->form;

    my %args = ( field => $field, maybe c => $form->ctx );

    if ( my $method = $form->can('template_args') ) {
        $form->$method( $field, \%args );
    }

    if ( my $method = $field->can('template_args') ) {
        $field->$method( \%args );
    }

    if ( my $method = $form->can( 'template_args_' . $form->name ) ) {
        $form->$method( $field, \%args );
    }

    return $self->template_renderer->( \%args );
}

1;
