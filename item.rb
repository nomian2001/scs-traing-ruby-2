class Item 
    @packing_style 
    @length
    @width
    @height
    @weight 
    @cog_height_type 
    @cog_height

    PACKING_STYLE_CASE = 'CASE'
    PACKING_STYLE_CRATE = 'CRATE'
    PACKING_STYLE_SKID = 'SKID'
    PACKING_STYLE_BARE = 'BARE'

    WIDTH_20FR_MAX = 380
    WIDTH_40FR_MAX = 470

    LENGTH_20FR_MAX = 529
    LENGTH_40FR_MAX = 1150

    def initialize(item)
        @packing_style = item['packing_style']
        @length = item['length'].to_i
        @width = item['width'].to_i
        @height = item['height'].to_i
        @weight = item['weight'].to_f
        @cog_height_type = item['cog_height_type']
        @cog_height = item['cog_height']
    end

    def get_packing_style
        @packing_style
    end

    def get_length
        @length
    end

    def get_width
        @width
    end

    def get_height
        @height
    end

    def get_weight
        @weight
    end

    def get_cog_height_type
        @cog_height_type
    end

    def get_cog_height
        @cog_height
    end

    def set_packing_style(packing_style)
        @packing_style = packing_style
    end

    def set_length(length)
        @length = length
    end

    def set_width(width)
        @width = width
    end

    def set_height(height)
        @height = height
    end

    def set_cog_height_type(cog_height_type)
        @cog_height_type = cog_height_type
    end

    def get_cog_height(cog_height)
        @cog_height = cog_height
    end
end





