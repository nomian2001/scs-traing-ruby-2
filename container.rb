require './item.rb'

class Container
    FR20 = "FR20"
    FR40 = "FR40"
    OT20 = "OT20"
    OT40 = "OT40"

    CONTAINER_RESULT_NG = "ng"
    CONTAINER_RESULT_OK = "ok"
    CONTAINER_RESULT_TBA = "tba"

    def initialize(container_type)
        @container_type = container_type
        @items = []
    end

    def get_container_type
        @container_type
    end

    def get_items
        @items
    end

    def set_container_type(container_type)
        @container_type = container_type
    end

    def push_item(item)
        @items.push(item) 
    end
    

end

