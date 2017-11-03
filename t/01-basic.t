#!/usr/bin/env perl

use Test::Most;

use lib 't/lib';

use_ok 'Form';

my $form = Form->new();
isa_ok $form, 'HTML::FormHandler';

ok my $field = $form->field('a'), 'field';

my $value = $field->value;

while ( $value < 1000 ) {

    $field->value( $field->default );

    chomp( my $default = $field->render );

    is $default,
      sprintf(
'<input name="a" type="checkbox" value="%u" x-field-method="a" x-form-method="a" x-form-method-a="b">',
        $field->default ),
      'expected output';

    $value++;

    $field->value($value);

    chomp( my $output = $field->render );

    is $output,
      sprintf(
'<input name="a" type="checkbox" value="%u" x-field-method="a" x-form-method="a" x-form-method-a="b">',
        $value ),
      'expected output';

}


done_testing;
