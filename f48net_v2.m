function net = f48net_v2()

opts.useBnorm = true ;

net.layers = {} ;
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{0.01*randn(5,5,3,64, 'single'), zeros(1, 64, 'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'pool', ...
    'method', 'max', ...
    'pool', [3 3], ...
    'stride', 2, ...
    'pad', 0) ;
%net.layers{end+1} = struct('type', 'normalize',...
 %   'param',[9 1 0.0001/5 0.75]) ;
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{0.01*randn(5,5,64,64, 'single'), zeros(1, 64, 'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
%net.layers{end+1} = struct('type', 'normalize',...
 %   'param',[9 1 0.0001/5 0.75]) ;
net.layers{end+1} = struct('type', 'pool', ...
    'method', 'max', ...
    'pool', [3 3], ...
    'stride', 2, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{0.01*randn(8,8,64,256, 'single'), zeros(1, 256, 'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'dropout',  'rate', 0.5) ;
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{0.01*randn(1,1,256,2, 'single'), zeros(1, 2, 'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
%{
net.layers{end+1} = struct('type', 'custom48', ...
    'weights', {{0.01*randn(1,1,400,2, 'single'), zeros(1, 2, 'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
%}
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'softmaxloss') ;


% optionally switch to batch normalization
if opts.useBnorm
    net = insertBnorm(net, 1) ;
    %net = insertBnorm(net, 4) ;
    %net = insertBnorm(net, 8) ;
    %net = insertBnorm(net, 12) ;
end

% --------------------------------------------------------------------
function net = insertBnorm(net, l)
% --------------------------------------------------------------------
assert(isfield(net.layers{l}, 'weights'));
ndim = size(net.layers{l}.weights{1}, 4);
layer = struct('type', 'bnorm', ...
    'weights', {{ones(ndim, 1, 'single'), zeros(ndim, 1, 'single')}}, ...
    'learningRate', [1 1], ...
    'weightDecay', [0 0]) ;
net.layers{l}.biases = [] ;
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;