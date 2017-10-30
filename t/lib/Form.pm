package Form;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has_field a => (
    widget        => 'Template',
);

sub template_path {
    my ($self, $field) = @_;
    return 't/etc/' . $field->name . '.tt';
}

1;
