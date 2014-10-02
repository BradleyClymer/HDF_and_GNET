function gather_hdf_fields
clc
g           = 'E:\Dropbox\FutureScan_team\Recorded Data Files\Orlando Data\2013-10-04 New GNet and highspeed firmware tests\2013-10-04 new gnet and highspeed firmware tests.media\Fusion\new.gnet'   ;
hdf_info    = h5info( g )    
hdf_info.Groups
find_sub_groups( hdf_info )
end

function find_sub_groups( hdf_info )
    groups = hdf_info.Groups 
    isempty( groups )
    if ~isempty( groups )
        disp( 'Calling again.' ) 
        find_sub_groups( groups.Groups )
    end
end