function out = h5ex_g_visit
%**************************************************************************
%  This example shows how to recursively traverse a file
%  using H5O.visit and H5L.visit.  The program prints all of
%  the objects in the file specified in FILE, then prints all
%  of the links in that file.  The default file used by this
%  example implements the structure described in the User's
%  Guide, chapter 4, figure 26.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************
clc
FILE =       'h5ex_g_visit.h5';
FILE =      fullfile( 'P:\Dropbox (Future Scan)\FutureScan_team\Recorded Data Files\Louisiana Data\LTU Data\2014-01-13 LTU Compaction Tests\2014-01-13 ltu compaction tests.media\Fusion' , ...
                      '2014-01-13 LTU Compaction Tests----1_13_2014 4_10 PM.gnet' )
fn          = 'a%d.gnet'      
folder      = 'P:\Dropbox (Future Scan)\EPAM\Data Files\2014-08-19 Data Sample\2014-08-19 data sample.media\Fusion'         ;
% FILE        = fullfile( folder, fn )                   
% g           = h5info( FILE ) 
%
% Open file
%
file = H5F.open (FILE, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

%
% Begin iteration using H5O.visit
%
disp ('Objects in the file:');
[ ~ , out ] = H5O.visit (file, 'H5_INDEX_NAME', 'H5_ITER_NATIVE',@hdf_op_func, []);
H5F.close (file);


end


function [status , opdataOut ]=op_func(rootId,name,opdataIn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Operator function for H5O.visit.  This function prints the
%name and type of the object passed to it.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('/');               % Print root group in object path %

objId=H5O.open(rootId,name,'H5P_DEFAULT');
info=H5O.get_info(objId);
H5O.close(objId);
split_string    = strsplit( name , '/' )
if name == '.'
   [status , opdataOut] = deal( [] )                            ;
   return
end
evalstring      = 'outstruct'                                   ;
ind_string   	= []                                            ;
field_string    = []                                            ;
outstruct       = struct                                        ;
num             = nan( [ numel( split_string , 1 ) ] )          ;
nom             = cell( size( num ) )                           ;
for i_levels = 1 : numel( split_string )
    [ nom{ i_levels } , num( i_levels ) ] = extract_index( split_string{ i_levels } )                      ;
    if num( i_levels )
        ind_string = sprintf( '( %d )' , num( i_levels ) )   	;
    else
        num_string = []                                         ;
    end
    field_string    = [ '.' nom{ i_levels } ]                   ;
    evalstring      = [ evalstring ind_string field_string ]    ;
    if i_levels == numel( split_string )
        evalstring  = [ evalstring '=name' ]                    ;
        eval( evalstring )                                      ;
    end
end
if isempty( opdataIn )
    opdataIn   = struct( 'groups' , [] , 'datasets' , [] , 'outstruct' , [] )         ;
end
opdataOut       = opdataIn                      ;

%
% Check if the current object is the root group, and if not print
% the full path name and type.
%
if (name(1) == '.')         % Root group, do not print '.' %
    fprintf ('  (Group)\n');
else
    switch (info.type)
        case H5ML.get_constant_value('H5O_TYPE_GROUP')
            disp ([name '\n(Group)']);
            opdataOut.groups{ end+1 }      = name               	;
        case H5ML.get_constant_value('H5O_TYPE_DATASET')
            disp ([name '\n(Dataset)']);
            opdataOut.datasets{ end+1 }    = name                   ;
        case H5ML.get_constant_value('H5O_TYPE_NAMED_DATATYPE')
            disp ([name ' (Datatype)']);
            
        otherwise
            disp ([name '  (Unknown)']);
    end
    
end
opdataOut.outstruct     = vertcat( opdataIn.outstruct , outstruct ) ;
status=0;
end

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