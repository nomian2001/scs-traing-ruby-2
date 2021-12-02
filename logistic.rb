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
        container_type = container.get_container_type()
        if(check_container_type(container_type))
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

    def check_container_type(container_type)
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
        flat_track_check_weight_distribution(item,container)
    end

    def flat_track_check_weight_distribution(item,container)
        length_item = item.get_length()
        weight_item = item.get_weight()
        container_type = container.get_container_type()
        if(container_type == Container::FR20)
            flat_track_check_weight_distribution_FR20(item,container_type)
        else
            flat_track_check_weight_distribution_FR40(item,container_type)
        end
        check_height(item,container)
    end

    def flat_track_check_weight_distribution_FR20(item,container_type)
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

    def flat_track_check_weight_distribution_FR40(item,container_type)
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

    def check_height(item,container)
        height_item = item.get_height()
        if(height_item > Item::MAX_HEIGHT || height_item < Item::MIN_HEIGHT)
            puts Message::MESSAGE5
        end
        flat_track_cog_calculation(item,container)
    end

    def flat_track_cog_calculation(item,container)
        cog_height_type = item.get_cog_height_type()
        case cog_height_type
        when Item::COG_HEIGHT_TYPE_HALF_OF_CARGO_HEIGHT_OR_LESS
            over_width_check(item,container)
        when Item::COG_HEIGHT_TYPE_MANUAL
            over_width_check(item,container)
        when Item::COG_HEIGHT_TYPE_TBA
            puts Message::MESSAGE10
            over_width_check(item,container)
        end
    end    

    def over_width_check(item,container)
        width_item = item.get_width()
        container_type = container.get_container_type()
        if(container_type == Container::FR20)
            over_width_check_FR20(item,container)
        else
            over_width_check_FR40(item,container)
        end
    end

    def over_width_check_FR20(item,container)
        width_item = item.get_width()
        if(width_item <= Item::WIDTH_20FR)
            cog_height_check_2(item,container)
        else
            cog_height_check_1(item,container)
        end 
    end

    def over_width_check_FR40(item,container)
        width_item = item.get_width()
        if(width_item <= Item::WIDTH_40FR)
            cog_height_check_2(item,container)
        else
            cog_height_check_1(item,container)
        end 
    end

    def cog_height_check_2(item,container)
        width_item = item.get_width()
        total_height = get_total_height_of_item_in_container(container)
        cog_value = (total_height/2).to_f
        if(cog_value > width_item * 0.865)
            puts Message::MESSAGE6
        end
    end
    
    def cog_height_check_1(item)
        width_item = item.get_width()
        total_height = get_total_height_of_item_in_container(container)
        cog_value = (total_height/2).to_f
        if(cog_value > Item::COG_HEIGHT_FLAT_TRACK)
            puts Message::MESSAGE6
        end
    end

    def get_total_height_of_item_in_container(container)
        total_height = 0
        container.get_items().each do |item|
            if(item.get_cog_height_type() == Item::COG_HEIGHT_TYPE_TBA)
                height_item = item.get_height()*0.5
            else 
                height_item = item.get_height()
            end
        end
        return total_height
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
        container.get_items().each do |item|
            packing_style_item = item.get_packing_style()
            if(packing_style_item.upcase == Item::PACKING_STYLE_BARE)
                puts  Message::MESSAGE1
            end
            open_top_cog_height_calculation(item)
        end
    end

    def open_top_cog_height_calculation(item)
        cog_height_type = item.get_cog_height_type()
        case cog_height_type
        when Item::COG_HEIGHT_TYPE_TBA
            puts Message::MESSAGE10
            open_top_cog_value_check(item)
        when Item::COG_HEIGHT_TYPE_MANUAL
            open_top_cog_value_check(item)
        when Item::COG_HEIGHT_TYPE_HALF_OF_CARGO_HEIGHT_OR_LESS
            open_top_cog_value_check(item)
        end
    end

    def open_top_cog_value_check(item)
        
    end
end