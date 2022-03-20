---@diagnostic disable: undefined-global
-- describe("Example test", function()
--     it("Check if numbers are equal", function()
--         assert.equal(3, 5 - 2)
--     end)
-- end)
describe("Util tests:", function()
    it("Get an option value", function()
        vim.cmd([[set relativenumber]])
        if vim.fn.has("nvim-0.7.0") then
            assert.equals(
                require("dynamic_help.utils").get_option_value("relativenumber"),
                "true"
            )
        end
    end)
    it("Get an option default value", function()
        vim.cmd([[set relativenumber]])
        if vim.fn.has("nvim-0.7.0") then
            assert.equals(
                require("dynamic_help.utils").get_default_option_value(
                    "relativenumber"
                ),
                "false"
            )
        end
    end)
    it("Get an invalid option default value", function()
        assert.equals(
            require("dynamic_help.utils").get_default_option_value(
                "a_random_invalid_option"
            ),
            ""
        )
    end)
    it("Get an invalid option value", function()
        assert.equals(
            require("dynamic_help.utils").get_option_value(
                "a_random_invalid_option"
            ),
            ""
        )
    end)
end)
