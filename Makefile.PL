use strict;
use warnings;
use inc::Module::Install;

name        'MooseX-FlexibleNames';
all_from    'lib/MooseX/FlexibleNames.pm';

requires 'Moose';

license     'perl';
author      'osfameron';

auto_install;
WriteAll;
