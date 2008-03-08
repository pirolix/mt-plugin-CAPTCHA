package MT::Plugin::OMV::CAPTCHA::Comment;
;#	CAPTCHA-Comment - Anti comment-spam with using CAPTCHA
;#	@see http://www.magicvox.net/archive/2006/06211659.php
;#			Programmed by Piroli YUKARINOMIYA (MagicVox)
;#			Open MagicVox.net - http://www.magicvox.net/
use strict;
use MT::Template::Context;
#use Data::Dumper;#DEBUG

require '/home/magicvox/www/www/cgi-bin/tgimpy/tgimpy.cgi';

use vars qw( $MYNAME $VERSION $RELEASE );
$MYNAME = 'CAPTCHA Comment';
$VERSION = '0.10';
$RELEASE = '080308';

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
MT->add_callback ('CommentThrottleFilter', 6, $plugin, \&filter);



;########################################################################
sub filter {
	my( $eh, $app, $obj ) = @_;
	my $q = $app->{query};
;#
	my $cfg = $q->param ('cfg') or return 0;
	my $ans = $q->param ('ans') or return 0;

    &TGimpy'CheckAnswer ($cfg, $obj->id, $ans); #'
}

1;
__END__
;########################################################################
# '08/03/08 0.10    ‰”ÅŒöŠJ
