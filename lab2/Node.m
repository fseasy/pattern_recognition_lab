classdef Node
    %NODE 定义神经网络中的节点，包含权值、经输入值
    %   此处显示详细说明
    
    properties
        w
        net
        id
    end
    
    methods
        function node = Node(nodeid , input_node_num)
            node.id = nodeid ;
            node.w = randn(input_node_num,1) ; % row : input_node_num , col : 1 
            node.net = 0
        end
        function netvalue = calc_net_value(x)
            netvalue = Node.w' * x ;
        end
    end
    
end

