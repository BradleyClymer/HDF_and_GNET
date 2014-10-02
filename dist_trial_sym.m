clear, close all hidden

x               = [   2      4.5         7.5 ]'
n.r             = [ 1 2 3    4 5       6 9 10 0]'
for i = 1 : numel( n.r )
    dif             = abs( n.r( i ) - x )                     ;
    best( i )       = find( dif == min( dif ) , 1 , 'first' )   ;
end

n.prod      = x * n.r'                                        ;
n.ref       = repmat( ( ( n.r ) .^2 )' , size( x , 1 ) , 1 )  ;

n.pd        = abs( -n.prod + n.ref )
n.m         = min( n.pd )
n.m_mat     = repmat( n.m , size( x , 1 ) , 1 )
find( n.pd == n.m_mat )
best

figure( 'Units' , 'Normalized' , 'Position' , [ 0.1 0.1 0.8 0.8 ] ) 
sp( 1 )     = subplot( 211 )                                        ;
imagesc( n.prod )
colorbar
axis equal tight

sp( 2 )     = subplot( 212 )                                        ;
imagesc( n.pd )
colorbar
axis equal tight

% linkprop( sp , 'Clim' ) 