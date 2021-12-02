require './container.rb'
require './item.rb'
require './message.rb'
require 'json'


class Logistic


    def initialize
        self.main()    
    end

    def main
        container = self.read_input()
        if(check_container_type(container))
            self.handle_flat_track_item(container)
        else
            self.handle.open_top_item(container)
        end
    end


    def read_input
        file = File.read('input.json')
        data_hash_input = JSON.parse(file)
        container = Container.new(data_hash_input['container_type'])
        data_hash_input['items'].each do |item|
            item = Item.new(item)
            container.push_item(item)
        end
        return container
    end

    def check_container_type(container)
        container_type = container.get_container_type()
        if(container_type == Container::FR20 || container_type == Container::FR40)
            true
        else
            false
        end
    end


    def handle_flat_track_item(container)
        container.get_items().each do |item|
            packing_style_item = item.get_packing_style()
            if(packing_style_item.upcase == Item::PACKING_STYLE_BARE || packing_style_item.upcase == Item::PACKING_STYLE_SKID)
                puts  Message::MESSAGE1
            end
            check_max_width(item,container)
        end
    end

    def check_max_width(item,container)
        if(item.get_width() > Item::WIDTH_20FR_MAX || item.get_width() > Item::WIDTH_40FR_MAX)
            puts Message::MESSAGE2
        end
        check_length(item,container)
    end
    
    def check_length(item,container)
        if(item.get_length() > Item::LENGTH_20FR_MAX || item.get_length() > Item::LENGTH_40FR_MAX)
            puts Message::MESSAGE3
        end
        check_weight_distribution(item,container)
    end

    def check_weight_distribution(item,container)
        length_item = item.get_length()
        weight_item = item.get_weight()
        container_type = container.get_container_type()
        if(container_type == Container::FR20)
            check_weight_distribution_FR20(item,container_type)
        else
            check_weight_distribution_FR40(item,container_type)
        end
        check_height(item)
    end

    def check_weight_distribution_FR20(item,container_type)
        length_item = item.get_length()
        weight_item = item.get_weight()
        if(Item::WEIGHT_20FR_MAX.key?(range_length(length_item,container_type)[0]) )
            if( (weight_item > Item::WEIGHT_20FR_MAX[range_length(length_item,container_type)[1]] ) ||
                (weight_item < Item::WEIGHT_20FR_MAX[range_length(length_item,container_type)[0]] )
            )
                puts Message::MESSAGE4
            end
        else
            puts Message::MESSAGE4
        end
    end

    def check_weight_distribution_FR40(item,container_type)
        length_item = item.get_length()
        weight_item = item.get_weight()
        if(Item::WEIGHT_40FR_MAX.key?(range_length(length_item,container_type)[0]) )
            if( (item.get_weight() > Item::WEIGHT_40FR_MAX[range_length(length_item,container_type)[1]] ) ||
                (item.get_weight() < Item::WEIGHT_40FR_MAX[range_length(length_item,container_type)[0]] )
            )
                puts Message::MESSAGE4
            end
        else
            puts Message::MESSAGE4 
        end
    end    

    def check_height(item)
        height_item = item.get_height()
        if(height_item > Item::MAX_HEIGHT || height_item < Item::MIN_HEIGHT)
            puts Message::MESSAGE5
        end
        
    end

    def range_length(number,container_type)
        length = number.to_s.length
        first_digit = number.to_s[0]
        start_range = first_digit.to_i * (10**(length.to_i - 1))
        if(container_type == Container::FR20)
            end_range = start_range + 50
        else
            end_range = start_range + 100
        end
        return [start_range,end_range]
    end

    def handle_open_top_item(container)
        puts "hello open top item"
    end
end