package Form;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use Template;

has template => (
    is      => 'ro',
    lazy    => 1,
    default => sub { Template->new },
);

has_field a => ( widget => 'Template', );

sub template_path {
    my ( $self, $field ) = @_;
    return 't/etc/' . $field->name . '.tt';
}

sub template_renderer {
    my ( $self, $field ) = @_;

    return sub {
        my ($args) = @_;
        $self->template->process( $self->template_path($field),
            $args, \my $output );
        return $output;
    };
}

1;
