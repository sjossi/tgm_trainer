local cpu = manager.machine.devices[":maincpu"]
local mem = cpu.spaces["program"]

local x_offset = 110
local y_offset = 70

local padding = 3

local line_offset = 20
local box_width = 40

local fg = 0xffff0000
local bg = 0xff000000

local addr_grade = 0x06079378
local addr_points = 0x06079379

local s = manager.machine.screens[":screen"]

local grades = {
    { "9",  steps = 1 }, -- 1
    { "8",  steps = 1 }, -- 2
    { "7",  steps = 1 }, -- 3
    { "6",  steps = 1 }, -- 4
    { "5",  steps = 1 }, -- 5
    { "4",  steps = 2 }, -- 6
    { "3",  steps = 2 }, -- 7
    { "2",  steps = 3 }, -- 8
    { "1",  steps = 3 }, -- 9
    { "S1", steps = 3 }, -- 10
    { "S2", steps = 1 }, -- 11
    { "S3", steps = 1 }, -- 12
    { "S4", steps = 3 }, -- 13
    { "S5", steps = 2 }, -- 14
    { "S6", steps = 2 }, -- 15
    { "S7", steps = 2 }, -- 16
    { "S8", steps = 2 }, -- 17
    { "S9", steps = 1 }, -- 18
}

local function to_grade(val)
    -- the grading system is a bit funky
    -- some grades exists for one internal grade, while others exist for two or three
    -- this table adds some information like internal grade
    local internal_to_external = {
        1,
        2,
        3,
        4,
        5,
        6, 6,
        7, 7,
        8, 8, 8,
        9, 9, 9,
        10, 10, 10,
        11,
        12,
        13, 13, 13,
        14, 14,
        15, 15,
        16, 16,
        17, 17,
        18,
    }

    return grades[internal_to_external[val + 1]]
end

local function line_y(lineno)
    return y_offset + line_offset * (lineno - 1) + padding
end

local function draw_hud()
    local line_x = x_offset + padding
    s:draw_box(x_offset, y_offset, x_offset + box_width + padding * 2, y_offset + 2 * line_offset + padding * 2, fg, bg)

    local grade_val = mem:read_u8(addr_grade)
    local grade_out = "GRADE\n"
    local next_grade = to_grade(grade_val+1)
    grade_out = grade_out .. string.format("%d -> %s", grade_val, next_grade[1])
    s:draw_text(line_x, line_y(1), grade_out, fg, bg)

    local points_val = mem:read_u8(addr_points)
    local points_out = "POINTS\n"
    points_out = points_out .. string.format("%d", points_val)
    s:draw_text(line_x, line_y(2), points_out, fg, bg)
end

emu.register_frame_done(draw_hud)
