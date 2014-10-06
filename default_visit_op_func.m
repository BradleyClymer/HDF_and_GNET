function [status , opdataOut]=default_visit_op_func(rootId,name,opdataIn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Operator function for H5O.visit.  This function prints the
%name and type of the object passed to it.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('/');               % Print root group in object path %
lastSlash=strfind( name , '/' )             ;
if ~isempty( lastSlash )
    endString   = name( lastSlash+1 : end ) 
end
opdataOut=[];
objId=H5O.open(rootId,name,'H5P_DEFAULT');
info=H5O.get_info(objId);
H5O.close(objId);

    opdataOut           = opdataIn                                      ;
    if isempty( opdataOut ) 
        opdataOut       = struct                                        ;
    end
    status              = 0                                             ;
    number_inds         = find( name > 47 & name < 58 , '1' , 'first' ) ;
    number_str          = name( number_inds )                           ;
    number              = str2num( number_str )                         ;
    opdataOut.fullNames = name                                          ;
%
% Check if the current object is the root group, and if not print
% the full path name and type.
%
if (name(1) == '.')         % Root group, do not print '.' %
    fprintf ('  (Group)\n');
    return
else
    switch (info.type)
        case H5ML.get_constant_value('H5O_TYPE_GROUP')
            disp ([name ' (Group)']);
            if strfind( name , 'Session' )
                
            end
            opdataOut       = struct( 'group' , name )
            opdataOut.group = name                       ;
            
            
        case H5ML.get_constant_value('H5O_TYPE_DATASET')
            disp ([name ' (Dataset)']);
            opdataOut.dataset = name                     ;
            
        case H5ML.get_constant_value('H5O_TYPE_NAMED_DATATYPE')
            disp ([name ' (Datatype)']);
            
        otherwise
            disp ([name '  (Unknown)']);
    end
    
end

dot_struct      = strrep( name , '/' , '.' )                ;
dot_with_inds   = strrep( dot_struct , '[' , '(' )          ;
dot_with_inds   = strrep( dot_with_inds , ']' , ')' )       ;
dot_with_inds   = strrep( dot_with_inds , ' ' , '' )        ;
eval_string     = [ 'opdataIn' dot_with_inds ' = name' ]
eval( eval_string )
% opdataOut       = vertcat( opdataIn , opdataOut )
in_string       = name                                      ;
opdataOut       = opdataIn                              	;

status=0;
end

function out_string = string2indeces( in_string )
%%
rot_st  = cellstr( strrep( in_string , '/' , sprintf( '\n' ) ) )
start   = strfind( in_string , '[' )
if ~isempty( start )
finish  = strfind( in_string , ']' )
index   = str2num( in_string( start(end)+1 : finish(end)-1 ) )
% textind = sprintf( '(
end


end