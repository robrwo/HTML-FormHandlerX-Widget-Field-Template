# NAME

HTML::FormHandlerX::Widget::Field::Template - render fields using templates

# VERSION

version v0.1.0

# SYNOPSIS

In a form class:

```perl
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
```

# DESCRIPTION

This is an [HTML::FormHandler](https://metacpan.org/pod/HTML::FormHandler) widget that allows you to use a
template for rendering forms instead of Perl methods.

# NAME

HTML::FormHandlerX::Widget::Field::Template - render fields using templates

# AUTHOR

Robert Rothenberg <rrwo@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017-2018 by Robert Rothenberg.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
