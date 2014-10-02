function status=defaul_op_func (loc_id, name)

%
% Get type of the object and display its name and type.
% The name of the object is passed to this function by
% the Library.
%
statbuf=H5G.get_objinfo (loc_id, name, 0);

switch (statbuf.type)
    case H5ML.get_constant_value('H5G_GROUP')
        fprintf ('  Group: %s\n', name);
        
    case H5ML.get_constant_value('H5G_DATASET')
        fprintf ('  Dataset: %s\n', name);
        
    case H5ML.get_constant_value('H5G_TYPE')
        fprintf ('  Datatype: %s\n', name);
        
    otherwise
        fprintf ( '  Unknown: %s\n', name);
end

status=0;

end