package Form;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has_field a => (
    widget        => 'Template',
    template_path => 't/etc/a.tt',
);

1;
