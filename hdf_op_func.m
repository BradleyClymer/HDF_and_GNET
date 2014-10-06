function [status , opdataOut ]=hdf_op_func(rootId,name,opdataIn)
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
split_string    = strsplit( name , '/' )                        ;
if name == '.'
   [status , opdataOut] = deal( [] )                            ;
   return
end
evalstring      = 'outstruct'                                   ;
ind_string   	= []                                            ;
field_string    = []                                            ;
outstruct       = struct                                        ;
num             = nan( numel( split_string , 1 ) )              ;
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
    opdataIn   = struct( 'Groups' , [] , 'datasets' , [] , 'outstruct' , [] , 'radar' , [] )         ;
end
opdataOut       = opdataIn                      ;

%
% Check if the current object is the root group, and if not print
% the full path name and type.
%
if (name(1) == '.')         % Root group, do not print '.' %
    fprintf ('  (Group)');
else
    switch (info.type)
        case H5ML.get_constant_value('H5O_TYPE_GROUP')
            disp ([name '  --- (Group)']);
            opdataOut.Groups{ end+1 }      = name               	;
        case H5ML.get_constant_value('H5O_TYPE_DATASET')
            disp ([name '  ---  (Dataset)']);
            opdataOut.datasets{ end+1 }    = name                   ;
            if regexp( name , 'Channel \[\d\]\/Data' ) 
                opdataOut.radar{ end+1 }   = name                   ;
            end
        case H5ML.get_constant_value('H5O_TYPE_NAMED_DATATYPE')
            disp ([name ' (Datatype)']);
            
        otherwise
            disp ([name '  (Unknown)']);
    end
    
end
opdataOut.outstruct     = horzcat( opdataIn.outstruct , outstruct ) ;
status=0;
end