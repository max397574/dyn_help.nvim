---@diagnostic disable: undefined-global
describe("Util tests:", function()
    it("Get an option value", function()
        vim.cmd([[set relativenumber]])
        if vim.fn.has("nvim-0.7.0") == 1 then
            assert.equals(
                require("dynamic_help.utils").get_option_value("relativenumber"),
                "true"
            )
        end
    end)
    it("Get an 0.6 compatible option value", function()
        vim.cmd([[set shiftwidth=4]])
        assert.equals(
            require("dynamic_help.utils").get_option_value("shiftwidth"),
            "4"
        )
    end)
    it("Get an option default value", function()
        vim.cmd([[set relativenumber]])
        assert.equals(
            require("dynamic_help.utils").get_default_option_value(
                "relativenumber"
            ),
            "false"
        )
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
