function [ name , num ] = extract_index( in_string )                                                                                ;
    if nargin == 0 
        in_string       = 'Session [1]'
    end
    num             = str2num( in_string( find( in_string > 47 & in_string < 58 , '1' , 'last' ) ) )        ;
    if isempty( num )
        num         = 0                                                                                     ;
    end
    split           = strsplit( in_string )                                                                 ;
    [ name , ~ ]    = deal( split{ : } )                                                                    ;
end