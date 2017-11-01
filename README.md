# NAME

HTML::FormHandlerX::Widget::Field::Template - render form fields using templates

# SYNOPSIS

In a form class:

    has_field foo => (
      widget        => 'Template',
      template_args => sub {
        my ($field, $args) = @_;
        ...
      },
    );

    sub template_renderer {
      my ( $self ) = @_;

      return sub {
          my ($field, $args) = @_;

          ...

      };
    }

# DESCRIPTION

This is an [HTML::FormHandler](https://metacpan.org/pod/HTML::FormHandler) widget that allows you to use a
template for rendering forms instead of Perl methods.
