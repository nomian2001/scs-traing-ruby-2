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

    COG_HEIGHT_TYPE_MANUAL = 'manual'
    COG_HEIGHT_TYPE_TBA = 'tba'
    COG_HEIGHT_TYPE_HALF_OF_CARGO_HEIGHT_OR_LESS = 'half_of_cargo_height_or_less'

    WIDTH_20FR_MAX = 380
    WIDTH_40FR_MAX = 470

    WIDTH_20FR = 243
    WIDTH_40FR = 243

    LENGTH_20FR_MAX = 529
    LENGTH_40FR_MAX = 1150

    MAX_HEIGHT = 518
    MIN_HEIGHT = 0

    COG_HEIGHT_FLAT_TRACK = 190
    COG_HEIGHT_OPEN_TOP = 211

    OT_WEIGHTDIST_20OT_MAX = 3.0
    OT_WEIGHTDIST_40OT_MAX = 4.5

    TOTAL_LENGTH_20FR = 597
    TOTAL_LENGTH_40FR = 1217.8

    TOTAL_LENGTH_20OT = 589
    TOTAL_LENGTH_40OT = 1200

    WEIGHT_20FR_MAX = {
        0 => 15350,
        50  => 16017,
        100 => 16745,
        150 => 17543,
        200 => 18420,
        250 => 19389,
        300 => 20467,
        350 => 21671,
        400 => 23025,
        450 => 24560,
        500 => 26314,
        550 => 28338,
        600 => 30700
    }

    WEIGHT_40FR_MAX = {
        0 => 19350,
        100 => 20191,
        200 => 21109,
        300 => 22114,
        400 => 23220,
        500 => 24442,
        600 => 25800,
        700 => 27318,
        800 => 29025,
        900 => 30960,
        1000 => 33171,
        1100 => 35723,
        1200 => 38700
    }


    def initialize(item)
        @packing_style = item['packing_style']
        @length = item['length'].to_i
        @width = item['width'].to_i
        @height = item['height'].to_i
        @weight = item['weight'].to_f
        @cog_height_type = item['cog_height_type']
        @cog_height = item['cog_height'].to_i
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

    def set_cog_height(cog_height)
        @cog_height = cog_height
    end
end





