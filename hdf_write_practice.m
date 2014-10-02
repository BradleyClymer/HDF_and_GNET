clear
clc

filename    = 'test.hdf'                                                                ;
fn          = fullfile( pwd , filename )

delete( fn )
ref_file    = 'E:\Dropbox (Future Scan)\FutureScan_team\Recorded Data Files\Orlando Data\2013_9_24 testing\9_24_2013 2_42 PM.hdf'
              load('C:\Users\bclymer\Desktop\Sample Data Files\Subtracted Rod Test, Ch 2.mat')              ;
              load('C:\Users\bclymer\Desktop\Installation Files\index_array_all.mat')                       ;
pic         = imread('C:\Users\bclymer\Documents\GitHub\annotated_graph.png')                               ;

%   File access
fcpl_id         = H5P.create( 'H5P_FILE_CREATE' )                                               % file creation property list
fapl_id         = H5P.create( 'H5P_FILE_ACCESS' )                                               % file access property list
fid             = H5F.create( fn , 'H5F_ACC_TRUNC' , fcpl_id , fapl_id )                        % trunc means overwrite existing

dims.pic        = ( size( pic ) )                                                                           ;
max_dims.pic    = dims.pic                                                                                  ;
type_id.pic     = H5T.copy( 'H5T_NATIVE_INT' )                                                              ;
type.pic        = H5T.array_create( type_id.pic , dims.pic )                                                ;
space.pic       = H5S.create_simple( numel( dims.pic ) , dims.pic , max_dims.pic )                          ;
dcpl.pic        = 'H5P_DEFAULT'                                                                             ;
                  

data_id.pic     = H5D.create( fid , 'pic' , type_id.pic , space.pic , dcpl.pic )                            ;
fill_time       = H5ML.get_constant_value( 'H5D_FILL_TIME_ALLOC' )                                          ;
%                   H5P.set_fill_time( data_id.pic , fill_time )                                               	;
%                   H5P.set_fill_value( data_id.pic , type_id.pic , -999 )                                   	;
                  H5D.write( data_id.pic , type_id.pic , 'H5S_ALL' , 'H5S_ALL' , dcpl.pic , uint32( pic ) )           


%   Dataset Access Properties
% lcpl
                  H5D.close( data_id.pic )
                  H5F.close( fid )  
h5disp( fn )
% h5disp( ref_file ) 
winopen( fn )