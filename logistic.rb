require './container.rb'
require './item.rb'
require './message.rb'
require 'json'


class Logistic

    def initialize
        self.main()    
    end

    def main
        container = self.read_input()[0]
        result = self.read_input()[1]
        container_type = container.get_container_type()
        if(container_type == Container::FR20 || container_type == Container::FR40)
            handle_flat_track_item(container,result)
        else
            handle_open_top_item(container,result)
        end
        convert_output_to_json(result)
    end


    def read_input
        file = File.read('input.json')
        data_hash_input = JSON.parse(file)
        result = data_hash_input
        container = Container.new(data_hash_input['container_type'])
        data_hash_input['items'].each do |item|
            item = Item.new(item)
            container.push_item(item)
        end
        return [container,result]
    end

    def convert_output_to_json(result)
        File.open("output.json","w") do |f|
            f.write(result.to_json)
        end
    end

    def handle_flat_track_item(container,result)
        container.get_items().each_with_index do |item,index_of_item|
            packing_style_item = item.get_packing_style()
            if(packing_style_item.upcase == Item::PACKING_STYLE_BARE || packing_style_item.upcase == Item::PACKING_STYLE_SKID)
                update_result_item_ng(result,index_of_item)
                update_message_item(result,Message::MESSAGE1,index_of_item)
            end
            check_max_width(item,container,result,index_of_item)
        end
    end

    def check_max_width(item,container,result,index_of_item)
        if(item.get_width() > Item::WIDTH_20FR_MAX || item.get_width() > Item::WIDTH_40FR_MAX)
            update_result_item_ng(result,index_of_item)
            update_message_item(result,Message::MESSAGE2,index_of_item)
        end
        check_length(item,container,result,index_of_item)
    end
    
    def check_length(item,container,result,index_of_item)
        if(item.get_length() > Item::LENGTH_20FR_MAX || item.get_length() > Item::LENGTH_40FR_MAX)
            update_result_item_ng(result,index_of_item)
            update_message_item(result,Message::MESSAGE3,index_of_item)
        end
        flat_track_check_weight_distribution(item,container,result,index_of_item)
    end

    def flat_track_check_weight_distribution(item,container,result,index_of_item)
        length_item = item.get_length()
        weight_item = item.get_weight()
        container_type = container.get_container_type()
        if(container_type == Container::FR20)
            flat_track_check_weight_distribution_FR20(item,container_type,result,index_of_item)
        else
            flat_track_check_weight_distribution_FR40(item,container_type,result,index_of_item)
        end
        check_height(item,container,result,index_of_item)
    end

    def flat_track_check_weight_distribution_FR20(item,container_type,result,index_of_item)
        length_item = item.get_length()
        weight_item = item.get_weight()
        if(Item::WEIGHT_20FR_MAX.key?(range_length(length_item,container_type)[0]) )
            if( (weight_item > Item::WEIGHT_20FR_MAX[range_length(length_item,container_type)[1]] ) ||
                (weight_item < Item::WEIGHT_20FR_MAX[range_length(length_item,container_type)[0]] )
            )
                update_result_item_ng(result,index_of_item)
                update_message_item(result,Message::MESSAGE4,index_of_item)
            end
        else
                update_result_item_ng(result,index_of_item)
                update_message_item(result,Message::MESSAGE4,index_of_item)
        end
    end

    def flat_track_check_weight_distribution_FR40(item,container_type,result,index_of_item)
        length_item = item.get_length()
        weight_item = item.get_weight()
        if(Item::WEIGHT_40FR_MAX.key?(range_length(length_item,container_type)[0]) )
            if( (item.get_weight() > Item::WEIGHT_40FR_MAX[range_length(length_item,container_type)[1]] ) ||
                (item.get_weight() < Item::WEIGHT_40FR_MAX[range_length(length_item,container_type)[0]] )
            )
                update_result_item_ng(result,index_of_item)
                update_message_item(result,Message::MESSAGE4,index_of_item)
            end
        else
                update_result_item_ng(result,index_of_item)
                update_message_item(result,Message::MESSAGE4,index_of_item)
        end
    end    

    def check_height(item,container,result,index_of_item)
        height_item = item.get_height()
        if(height_item > Item::MAX_HEIGHT || height_item < Item::MIN_HEIGHT)
            update_result_item_ng(result,index_of_item)
            update_message_item(result,Message::MESSAGE5,index_of_item)
        end
        flat_track_cog_calculation(item,container,result,index_of_item)
    end

    def flat_track_cog_calculation(item,container,result,index_of_item)
        cog_height_type = item.get_cog_height_type()
        case cog_height_type
        when Item::COG_HEIGHT_TYPE_HALF_OF_CARGO_HEIGHT_OR_LESS
            over_width_check(item,container,result,index_of_item)
        when Item::COG_HEIGHT_TYPE_MANUAL
            over_width_check(item,container,result,index_of_item)
        when Item::COG_HEIGHT_TYPE_TBA
            update_total_size_container(result,container)
            update_message_container(result,Message::MESSAGE10)
            over_width_check(item,container,result,index_of_item)
        end
    end    

    def over_width_check(item,container,result,index_of_item)
        width_item = item.get_width()
        container_type = container.get_container_type()
        if(container_type == Container::FR20)
            over_width_check_FR20(item,container,result,index_of_item)
        else
            over_width_check_FR40(item,container,result,index_of_item)
        end
    end

    def over_width_check_FR20(item,container,result,index_of_item)
        width_item = item.get_width()
        if(width_item <= Item::WIDTH_20FR)
            cog_height_check_2(item,container,result,index_of_item)
        else
            cog_height_check_1(item,container,result,index_of_item)
        end 
    end

    def over_width_check_FR40(item,container,result,index_of_item)
        width_item = item.get_width()
        if(width_item <= Item::WIDTH_40FR)
            cog_height_check_2(item,container,result,index_of_item)
        else
            cog_height_check_1(item,container,result,index_of_item)
        end 
    end

    def cog_height_check_2(item,container,result,index_of_item)
        width_item = item.get_width()
        total_height = get_total_height_of_item_in_container(container)
        cog_value = (total_height/2).to_f
        if(cog_value > width_item * 0.865)
            update_result_item_ng(result,index_of_item)
            update_message_item(result,Message::MESSAGE6,index_of_item)
        end

        total_length_check(item,container,result)
    end
    
    def cog_height_check_1(item,container,result,index_of_item)
        width_item = item.get_width()
        total_height = get_total_height_of_item_in_container(container)
        cog_value = (total_height/2).to_f
        if(cog_value > Item::COG_HEIGHT_FLAT_TRACK)
            update_result_item_ng(result,index_of_item)
            update_message_item(result,Message::MESSAGE6,index_of_item)
        end
        total_length_check(item,container,result)
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

    def handle_open_top_item(container,result,index_of_item)
        container.get_items().each do |item|
            packing_style_item = item.get_packing_style()
            if(packing_style_item.upcase == Item::PACKING_STYLE_BARE)
                update_result_item_ng(result,index_of_item)
                update_message_item(result,Message::MESSAGE1,index_of_item)
            end
            open_top_cog_height_calculation(item,container,result,index_of_item)
        end
    end

    def open_top_cog_height_calculation(item,container,result,index_of_item)
        cog_height_type = item.get_cog_height_type()
        case cog_height_type
        when Item::COG_HEIGHT_TYPE_TBA
            update_total_size_container(result,container)
            update_message_container(result,Message::MESSAGE10)
            open_top_cog_value_check(item,container,result,index_of_item)
        when Item::COG_HEIGHT_TYPE_MANUAL
            open_top_cog_value_check(item,container,result,index_of_item)
        when Item::COG_HEIGHT_TYPE_HALF_OF_CARGO_HEIGHT_OR_LESS
            open_top_cog_value_check(item,container,result,index_of_item)
        end
    end

    def open_top_cog_value_check(item,container,result,index_of_item)
        cog_height_type = item.get_cog_height_type()
        if( (cog_height_type == Item::COG_HEIGHT_TYPE_HALF_OF_CARGO_HEIGHT_OR_LESS) ||
            (cog_height_type == Item::COG_HEIGHT_TYPE_TBA)
        )
            cog_value = item.get_height()*0.5
        else
            cog_value = item.get_height()
        end
        if(cog_value > Item::COG_HEIGHT_OPEN_TOP)
            update_result_item_ng(result,index_of_item)
            update_message_item(result, Message::MESSAGE6,index_of_item)
        end
        open_top_weight_distribution_check(item,container,result,index_of_item)
    end

    def open_top_weight_distribution_check(item,container,result,index_of_item)
        weight_item = item.get_weight()
        length_item = item.get_length()
        max_weight_distribution = (weight_item / length_item).to_f
        container_type = container.get_container_type()
        if((container_type == Container::OT20 && max_weight_distribution > Item::OT_WEIGHTDIST_20OT_MAX) || 
            (container_type == Container::OT40 && max_weight_distribution > Item::OT_WEIGHTDIST_40OT_MAX)
        )
            update_result_item_ng(result,index_of_item)
            update_message_item(result,Message::MESSAGE7,index_of_item)
        end
        
        total_length_check(item,container,result)
    end

    def total_length_check(item,container,result)
        total_length = total_length_in_container(container)
        container_type = container.get_container_type()
        case container_type
        when Container::FR20
            if(total_length > Item::TOTAL_LENGTH_20FR)
                update_message_container(result,Message::MESSAGE8)
            end
        when Container::FR40
            if(total_length > Item::TOTAL_LENGTH_40FR)
                update_message_container(result,Message::MESSAGE8)
            end
        when Container::OT20
            if(total_length > Item::TOTAL_LENGTH_20OT)
                update_message_container(result,Message::MESSAGE8)
            end
        when Container::OT40
            if(total_length > Item::TOTAL_LENGTH_40OT)
                update_message_container(result,Message::MESSAGE8)
            end
        end
        total_weight_check(item,container,result)
    end

    def total_weight_check(item,container,result)
        total_weight = total_length_in_container(container)
        container_type = container.get_container_type()
        case container_type
        when Container::FR20
            if(total_weight > Item::TOTAL_WEIGHT_20FR)
                update_message_container(result,Message::MESSAGE9)
            end
        when Container::FR40
            if(total_weight > Item::TOTAL_WEIGHT_40FR)
                update_message_container(result,Message::MESSAGE9)
            end
        when Container::OT20
            if(total_weight > Item::TOTAL_WEIGHT_20OT)
                update_message_container(result,Message::MESSAGE9)
            end
        when Container::OT40
            if(total_weight > Item::TOTAL_WEIGHT_40OT)
                update_message_container(result,Message::MESSAGE9)
            end
        end
    end

    def total_weight_in_container(container)
        items = container.get_items()
        total_weight = 0
        items.each do |item|
            weight_item = item.get_weight()
            total_weight = total_weight + weight_item
        end
        return total_weight
    end

    def total_length_in_container(container)
        items = container.get_items()
        total_length = 0
        items.each do |item|
            length_item = item.get_length()
            total_length = total_length + length_item
        end
        return total_length
    end

    def update_message_item(result,message,index_of_item)
        if(result['items'][index_of_item].has_key?('remark'))                   #check if inside of item has key "remark" or not
            if(!result['items'][index_of_item]['remark'].include?(message))             #check if message is existed in remark
                tmp_message = result['items'][index_of_item]['remark']
                result['items'][index_of_item]['remark'] = "#{tmp_message} \n" + "#{message}"
            end
        else
            result['items'][index_of_item]['remark'] = message
        end
    end

    def update_message_container(result,message)
        if(result.has_key?('total_remark'))                     #check if inside of container has key "total_remark" or not
            if(!result['total_remark'].include?(message))         #check if message is existed in key "total_remark"
                tmp_message = result['total_remark']
                result['total_remark'] = "#{tmp_message} \n" + "#{message}"
            end
        else
            result['total_remark'] = message
        end
    end

    def update_result_item_ng(result,index_of_item)
            result['items'][index_of_item]['result'] = Item::ITEM_RESULT_NG 
    end

    def update_result_item_ok(result,index_of_item)
        result['items'][index_of_item]['result'] = Item::ITEM_RESULT_OK
    end

    def update_total_size_container(result,container)
        result['total_length'] = total_length_in_container(container)
        result['total_weight'] = total_weight_in_container(container)
    end

end