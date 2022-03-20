---@diagnostic disable: undefined-global
describe("Util tests (option values):", function()
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

describe("Util tests (help tags):", function()
    it("Get help tag lines", function()
        local help_tag_lines = require("dynamic_help.utils").get_help_tag_lines(
            "help"
        )
        assert.are.same(
            help_tag_lines,
            {
                "help",
                "\t\t\t*help* *<Help>* *:h* *:help* *<F1>* *i_<F1>* *i_<Help>*",
                "<Help>\t\tor",
                ":h[elp]\t\t\tOpen a window and display the help file in read-only",
                "\t\t\tmode.  If there is a help window open already, use",
                "\t\t\tthat one.  Otherwise, if the current window uses the",
                "\t\t\tfull width of the screen or is at least 80 characters",
                "\t\t\twide, the help window will appear just above the",
                "\t\t\tcurrent window.  Otherwise the new window is put at",
                "\t\t\tthe very top.",
                "\t\t\tThe 'helplang' option is used to select a language, if",
                "\t\t\tthe main help file is available in several languages.",
                "",
                "\t\t\tType |gO| to see the table of contents.",
                "",
            }
        )
    end)
end)
