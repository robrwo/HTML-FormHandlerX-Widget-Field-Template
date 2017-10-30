#!/usr/bin/env perl

use Test::Most;

use lib 't/lib';

use_ok 'Form';

my $form = Form->new();
isa_ok $form, 'HTML::FormHandler';

ok my $field = $form->field('a'), 'field';

note my $output = $field->render;




done_testing;
