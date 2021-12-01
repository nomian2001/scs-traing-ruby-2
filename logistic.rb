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
        if(container_type.upcase == Container::FR20 || container_type.upcase == Container::FR40 )
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

    def handle_flat_track_item(container)
        container.get_items().each do |item|
            packing_style_item = item.get_packing_style()
            if(packing_style_item.upcase == Item::PACKING_STYLE_BARE || packing_style_item.upcase == Item::PACKING_STYLE_SKID)
                puts  Message::MESSAGE1
            end
            check_max_width(item)
        end
    end

    def check_max_width(item)
        if(item.get_width() > Item::WIDTH_20FR_MAX || item.get_width() > Item::WIDTH_40FR_MAX)
            puts Message::MESSAGE2
        end
        check_length(item)
    end
    
    def check_length(item)
        if(item.get_length() > Item::LENGTH_20FR_MAX || item.get_length() > Item::LENGTH_40FR_MAX)
            puts Message::MESSAGE3
        end
        check_weight_distribution(item)
    end

end