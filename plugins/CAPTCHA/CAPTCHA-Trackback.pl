package MT::Plugin::OMV::CAPTCHA::TB;
;#	MT-CAPTCHA-TB - Anti trackback-spam with using CAPTCHA
;#	@see http://www.magicvox.net/archive/2006/06211659.php
;#			Programmed by Piroli YUKARINOMIYA (MagicVox)
;#			Open MagicVox.net - http://www.magicvox.net/
use strict;
use MT::Template::Context;
#use Data::Dumper;#DEBUG

require '/home/magicvox/www/www/cgi-bin/tgimpy/tgimpy.cgi';

use vars qw( $MYNAME $VERSION $RELEASE );
$MYNAME = 'CAPTCHA Trackback';
$VERSION = '0.10';
$RELEASE = '621';

;# Create an plugin instance
my $plugin;
if (MT->can ('add_plugin'))
{
	require MT::Plugin;
	$plugin = MT::Plugin->new;
		$plugin->name (sprintf '%s ver.%s (Release %s)', $MYNAME, $VERSION, $RELEASE);
		$plugin->description ('Avoid the trackback spams with CAPTCHA');
		$plugin->doc_link ('http://www.magicvox.net/archive/2006/06211659.php');
	MT->add_plugin ($plugin);
}
sub instance { $plugin; }

;# Register handlers
MT->add_callback ('TBPingThrottleFilter', 6, $plugin, \&filter);



;########################################################################
sub filter {
	my ($eh, $app, $obj) = @_;
	my $q = $app->{query};
;#
	;# Re-retrieve passphrase orz
	my ($tb_id, $cfg, $pass) = ('', '', '');
	if ($q->param('tb_id')) {
		($cfg, $pass) = split /\//, $q->param('pass') if defined $q->param('pass');
	} else {
		if (my $pi = $app->path_info) {
			$pi =~ s!^/!!;
			($tb_id, $cfg, $pass) = split /\//, $pi;
		}
	}

	;# Overwrite with just $pass when CAPTCHA check is passed.
	if (&TGimpy'CheckAnswer ($cfg, $obj->entry_id, $pass)) { #'
		$obj->passphrase ($cfg);
	} else {
		$obj->passphrase ($$. rand (time ()));# Hey, guess me :D
	}
	return 1;
}

1;
__END__
;########################################################################
2006/06/21	0.10	‰”ÅŒöŠJ
