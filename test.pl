#########################

###use Data::Dumper ; print Dumper(  ) ;

use Test;
BEGIN { plan tests => 1 } ;

use Date::Object ;

use strict ;
use warnings qw'all' ;

sub synchronize {
  print "Synchronizing clock seconds...\n" ;
  my $time = time ;
  while( $time == time ) { select(undef,undef,undef,0.01) ;}
}

#########################
{

  synchronize() ;
  my $d0 = Date::O() ;
  my $d1 = Date::O_zone(-3) ;
  my $d2 = Date::O_local() ;
  
  ok($d0 == $d1) ;
  ok($d1 == $d2) ;
  
  my $d01 = Date::Object->new() ;
  my $d11 = Date::Object->new_zone(-3) ;
  my $d21 = Date::Object->new_local() ;
  
  ok($d0 == $d01) ;
  ok($d1 == $d11) ;
  ok($d2 == $d21) ;
  
  my $d02 = Date::Object->new($d0) ;
  my $d12 = Date::Object->new_zone(-3 , $d0) ;
  my $d22 = Date::Object->new_local($d0) ;
  
  ok($d0 == $d02) ;
  ok($d1 == $d12) ;
  ok($d2 == $d22) ;  
  
  ok( $d02->zone == 0 ) ;
  ok( $d12->zone == -3 ) ;
  
}
#########################
{

  my $d0 = Date::O_zone( -3 , 2004 , 1 , 1 ) ;
  my $d1 = Date::O_zone( 0 , 2004 , 1 , 1 ) ;
  
  ok($d0 > $d1) ;
  
  my $d2 = Date::O_zone( 0 , 2004 , 1 , 1 ) ;
  my $d3 = Date::O_zone( 0 , 2004 , 1 , 2 ) ;
  
  ok($d2 < $d3) ;

}
#########################
{
  
  my ($year , $mon , $mday , $hour , $min , $sec) = qw(2004 03 20 23 20 34) ;
  
  my $d0 = Date::O( $year , $mon , $mday , $hour , $min , $sec ) ;
  my $d1 = Date::O_zone( -3 , $year , $mon , $mday , $hour , $min , $sec ) ;
  my $d2 = Date::O_local( $year , $mon , $mday , $hour , $min , $sec ) ;
  
  ok($d0->date_zone , "2004-03-20 23:20:34 +0000") ;
  ok($d1->date_zone , "2004-03-20 23:20:34 -0300") ;
  ok($d2->date_zone , "2004-03-20 23:20:34 " . $d2->zone_gmt) ;  
  
  $d0->set_zone(-3) ;
  ok($d0->date_zone , "2004-03-20 20:20:34 -0300") ;
  
}
#########################
{

  synchronize() ;
  my $d0 = Date::O_local() ;
  my $d1 = Date::O() ;
  my $d2 = Date::O() ;
  my $d3 = Date::O_local() ;
  
  $d1->set_local ;
  ok($d0 == $d1) ;
  ok($d1->date , $d0->date) ;  
  
  $d3->set_local ;
  ok($d3->date , $d1->date) ;

  $d2->set_zone( $d0->zone ) ;
  ok($d0 == $d2) ;
  
}
#########################
{

  my $d0 = Date::O_zone(-3 , 2004 , 1 , 1) ;
  my $d1 = Date::O_gmt(2004 , 1 , 1) ;
  
  ok($d0->hours_from($d1) , 3) ;
  ok($d0->hours_until($d1) , -3) ;
  ok($d0->hours_between($d1) , 3) ;  
  
  $d0 = Date::O_zone(3 , 2004 , 1 , 1) ;
  $d1 = Date::O_gmt(2004 , 1 , 1) ;
  
  ok($d0->hours_from($d1) , -3) ;
  ok($d0->hours_until($d1) , 3) ;
  ok($d0->hours_between($d1) , 3) ;  

}
#########################
{

  synchronize() ;
  my $d0 = Date::O(2004 , 2 , 29) ;
  
  ok($d0->date , "2004-02-29 00:00:00") ;
  
  $d0->sub_year(1) ;
  
  ok($d0->date , "2003-02-28 00:00:00") ;
  
  $d0->add_year(1) ;
  
  ok($d0->date , "2004-02-28 00:00:00") ;
  
}
#########################

print "\nThe End! By!\n" ;

1 ;
