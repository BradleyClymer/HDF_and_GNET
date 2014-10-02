
clc
close all
clear
% cd include
% addpath( genpath( 'include' ) )
% libraries   = dir( fullfile( 'include' , '*.h' ) )                ;
success     = []
failure     = []
start_dir   = pwd                                               ;
fn          = 'a%d.gnet'      
folder      = 'P:\Dropbox (Future Scan)\EPAM\Data Files\2014-08-19 Data Sample\2014-08-19 data sample.media\Fusion'         ;
infile      = fullfile( folder, fn )                                                                                        ;
plist       = 'H5P_DEFAULT';
fapl        = H5P.create('H5P_FILE_ACCESS');
              H5P.set_fapl_family(fapl, 0, plist);
fid         = H5F.open( infile , 'H5F_ACC_RDONLY' , fapl )    	;
gid_inf     = H5G.get_info( fid )
gid         = H5G.open(fid,'/Session [1]/Radar [1]/')           ;
gid_root    = H5G.open( fid , '/' )                             ;
idx_type    = 'H5_INDEX_NAME'                                   ;
order       = 'H5_ITER_NATIVE'                                     ;
% info        = h5info( infile )                                  ;
dset_id     = H5D.open(gid,'/Session [1]/Distance [1]/Data')    ;
% info        = H5O.get_info(dset_id)                             ;
d           = H5D.read( dset_id )                               
idx_in      = 1                                                 ;   % start at first group
% iter_func   = @(group_id,name,opdata_in)                        ...
% info        = h5info( infile )     
              
% [status,idx_out,opdata_out] = H5L.iterate( gid_root , 'H5_INDEX_CRT_ORDER' , order , idx_in , iter_func,opdata_in)
H5G.iterate (gid, '/',[] , @default_op_func);
% H5O.visit(gid, '/',[] , @default_op_func);
[status, opdata_out] = H5O.visit (fid, 'H5_INDEX_NAME', 'H5_ITER_NATIVE',@default_visit_op_func, [] );
% visit(obj_id,index_type,order,cbFunc,opdata_in)
% iterate(loc_id, name, idx, iter_func)

H5G.close(gid);
H5F.close(fid);

% plotyy( [ 1 2 ] , d.timestamp , [ 1 2 ]  , d.value )
subplot( 121 ) 
plot( [ 1 2 ] , d.timestamp  )
subplot( 122 )
plot( [ 1 2 ] , d.value )