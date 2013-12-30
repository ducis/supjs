#!/usr/bin/perl
package SuperJS;
use utf8;
use open qw(:std :utf8);
use Parse::RecDescent;
use File::Slurp;
$/=undef;

my $文法 = <<'END'
{
	use Data::Dumper;
	use feature "switch";
	our ($l,$r);
	sub assignment_unpack_array;
	sub assignment_final{
		print "\nvar $l=$r;";
	}
	sub assignment_branch_left{
		local ($l,$r) = @_;
		given (ref){
			when ("ARRAY"){assignment_unpack_array}
			default {assignment_final}
		}
	}
	sub assignment_unpack_array{
		my $i=0;
		for (@{$l}){
			#print "$_\n$r\n";
			assignment_branch_left($_,$r."[$i]");
			++$i;
		}
	}
	sub assignment{
		local ($l,$r) = @_;
		given([map {ref} @_]){
			when (["ARRAY",""]) { assignment_unpack_array(@_) }
			when (["","ARRAY"]) { die "unimpl SA" }
			when (["ARRAY","ARRAY"]) {	die "unimpl AA"}
			when (["",""]) {print "RRRRRRRR"}
			default {die "SSSSSSSSSSSSSSSSSSS"}
		}
	}
}
bypassed:
	/([^{]|{[^╋])*/
	{
		print "$item[1]";
	}
fulltext:
	<leftop:bypassed ('{╋' supjs '╋}') bypassed>
supjs:
	句(s /;/) { print "\n"; }
名:
	/([\p{Han}a-zA-Z])((?1)|[0-9])*/ 
物:
	名
	| '[' 表 ']' {$return = $item[2]}
表:
	物(s /,/)
	{
		$return = $item[1];
	}
句:	
	物 '=' 物
	{
		assignment ($item[1], $item[3]);
		$return = "";
	}
	| 物
END
;

new Parse::RecDescent($文法)->fulltext(<>);
