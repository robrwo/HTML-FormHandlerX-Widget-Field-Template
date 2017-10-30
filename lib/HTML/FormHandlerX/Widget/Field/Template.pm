package HTML::FormHandlerX::Widget::Field::Template;

use Moose::Role;

use MooseX::MungeHas;
use PerlX::Maybe;
use Ref::Util qw/ is_ref is_blessed_ref is_coderef /;
use Template;
use Types::Standard -types;

use namespace::autoclean;

has template_path => ( is => 'ro', );

has template_path => (
    is  => 'lazy',
    isa => Str,
);

sub _build_template_path {
    my ($self) = @_;
    if ( $self->form->can('template_path') ) {
        return $self->form->template_path($self);
    }
    return;
}

has template => (
    is  => 'lazy',
    isa => InstanceOf ['Template'],

    # coerce => sub {
    #     my ($value) = @_;

    #     return $value if is_blessed_ref($value) && $value->isa('Template');

    #     return $value->() if is_coderef($value);
    # },
);

sub _build_template {
    my ($self) = @_;
    if ( $self->form->can('template') ) {
        return $self->form->template;
    }
    return Template->new();
}

sub render {
    my ( $self, $result ) = @_;
    $result ||= $self->result;
    die "No result for form field '"
      . $self->full_name
      . "'. Field may be inactive."
      unless $result;

    # FIXME this is a role in a field?

    my $field = $result->field_def;
    my $form  = $field->form;

    my %stash = ( field => $field, maybe c => $form->ctx );

    if ( my $method = $form->can('template_stash') ) {
        $form->$method( $field, \%stash );
    }

    if ( my $method = $field->can('template_stash') ) {
        $field->$method( \%stash );
    }

    if ( my $method = $form->can( 'template_stash_ ' . $form->name ) ) {
        $form->$method( $field, \%stash );
    }

    my $tmpl_path = $self->template_path;

    die "No template is specified for '" . $field->full_name . "'."
      unless $tmpl_path;

    die "Cannot find template ${tmpl_path}" unless -e $tmpl_path;

    $self->template->process( $tmpl_path, \%stash, \my $output );

    return $output;
}

1;
