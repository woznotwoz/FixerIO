.::FixerIO(3)         User Contributed Perl Documentation        .::FixerIO(3)



NNAAMMEE
       FixerIO.pm - Object oriented access to the fixer.io currency exchange
       rate API. See, "http://fixer.io/documentation".

SSYYNNOOPPSSIISS
           use FixerIO;

           my $accessKey = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

           my $availableSymbols = FixerIO->new($accessKey)->api_symbols()->get_response();

           while (my ($symbol, $description) = each %$availableSymbols) {
               print "$symbol - $description\n";
           }

DDEESSCCRRIIPPTTIIOONN
       This is an object oriented Perl library for accessing the API provided
       by the http://fixer.io website.

       This is a work in progress. It doesn't even have a version number.

       The main features of the library are:

       +o  Provides seperate modules for accessing each endpoint of the API.
          Which may be used on thier own.

       +o  Provides ease of use and options that allow the script writer to
          efficiently create a script that helps get work done.

       +o  Supports many features available in the API.

       +o  The Perl code is written as much as possible to be the Perl
          translation of the english documentation.  So, you can look at, say,
          FixerIO::Symbols.pm, and see that URL for the request is assembled
          just as it is shown in the documentation on the site.  The response
          is the same way.

       +o  Someday, maybe, some command line clients will be included.  But
          right now it's easy to slap a one liner out, yourself.

AAPPII FFEEAATTUURREESS IIMMPPLLEEMMEENNTTEEDD BBYY TTHHIISS LLIIBBRRAARRYY
       The documentation is at <URL:https://fixer.io/documentation/>

       These features are listed as they appear in the documentation.

   AAPPII KKeeyy
       You have to obtain your own API key from the fixer.io web site.

   AAvvaaiillaabbllee EEnnddppooiinnttss
       ( Copied from the documentation on the site. )

       The Fixer API comes with X API endpoints, each providing a different
       functionality. Please note that depending on your subscription plan,
       certain API endpoints may or may not be available.

       +o  Latest rates endpoint Returns real-time exchange rate data for all
          available or a specific set of currencies.

       +o  Convert endpoint Allows for conversion of any amount from one
          currency to another.

       +o  Historical rates endpoint Returns historical exchange rate data for
          all available or a specific set of currencies.

       +o  Time-Series data endpoint Returns daily historical exchange rate
          data between two specified dates for all available or a specific set
          of currencies.

       +o  Fluctuation data endpoint Returns fluctuation data between two
          specified dates for all available or a specific set of currencies.

   SSSSLL CCoonnnneeccttiioonn
       ( not implemented ) Switch from plain HTTP to HTTPS with the
       _s_s_l___c_o_n_n_e_c_t_i_o_n_(_) method.

   HHTTTTPP EEttaaggss
       This is implemented and is used automatically.  You can force a new
       response from the end point with the _f_o_r_c_e___n_e_w_(_) method.

   PPootteennttiiaall EErrrroorrss
       When the end point responds with an error object, this library returns
       a FixerIO::Error::Response object.

   SSppeecciiffyy SSyymmbboollss
       Use the _s_y_m_b_o_l_s_(_) method to provide a list of the symbols you are
       interested in.  The default is that you get them all.

   CChhaannggiinngg BBaassee CCuurrrreennccyy
       Use the _b_a_s_e_(_) method to provide the base currency. The default is the
       Euro, (EUR).

   EEnnddppooiinnttss
       _S_u_p_p_o_r_t_e_d _S_y_m_b_o_l_s _E_n_d_p_o_i_n_t

       _L_a_t_e_s_t _R_a_t_e_s _E_n_d_p_o_i_n_t

       _H_i_s_t_o_r_i_c_a_l _R_a_t_e_s _E_n_d_p_o_i_n_t

       _C_o_n_v_e_r_t _E_n_d_p_o_i_n_t

       _T_i_m_e_-_S_e_r_i_e_s _E_n_d_p_o_i_n_t

       _F_l_u_c_t_u_a_t_i_o_n _E_n_d_p_o_i_n_t

OOVVEERRVVIIEEWW OOFF CCLLAASSSSEESS AANNDD PPAACCKKAAGGEESS
MMOORREE DDOOCCUUMMEENNTTAATTIIOONN
EENNVVIIRROONNMMEENNTT
       The following environment variables are used

       none, currently

AAUUTTHHOORR
       Harry Wozniak

CCOOPPYYRRIIGGHHTT
         Copyright 2018, Harry Wozniak

       This library is free software; you can redistribute it and/or modify it
       under the same terms as Perl itself.

AAVVAAIILLAABBIILLIITTYY
       CPAN, someday, maybe.

         https://github.com/woznotwoz/FixerIO.pm



perl v5.18.2                      2018-05-29                     .::FixerIO(3)
