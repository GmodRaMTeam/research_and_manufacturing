<research-menu show="{ show_research_menu }">
    <div class="ui grid">
        <div class="ui row">
            <div class="ui sixteen wide column segment">
                awefpinwapinwankfwapkfwa
                <div class="ui top attached tabular menu">
                    <a each="{category in research_menu}" class="item" data-tab="{category.key}">{category.name}</a>
                </div>
            </div>
        </div>
    </div>
    <script>
        var self = this;
        self.show_research_menu = false

        /**********************************************************************
         * Init
         *********************************************************************/
        self.on('mount', function () {
            update_loop();
        })

        /**********************************************************************
         * Methods
         *********************************************************************/
        var update_loop = function () {
            // player may not exist if we're testing in local browser, wait for it
            if (typeof researchMenu !== 'undefined' && typeof researchMenu.update === 'function') {
                var temp_result = researchMenu.update()
                if (temp_result !== null && typeof temp_result !== 'undefined'){
                    console.log(temp_result)
                    self.update({
                        research_menu: JSON.parse(temp_result),
                    })
                }

                window.setTimeout(update_loop, 25);
            }

            var do_something = function () {
                if (typeof test !== 'undefined' && typeof test.test !== 'undefined') {
                    test.test()
                }
                console.log("AGWAGAWGWGA")
            }
        }

            /**********************************************************************
             * Events
             *********************************************************************/
            EVENTS.on('toggle_research_menu', function () {
                self.show_research_menu = !self.show_research_menu
                self.update()
            })
    </script>
    <style scoped>
    </style>
</research-menu>