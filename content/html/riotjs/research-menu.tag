<research-menu>
    <button show="{ !IS_IN_GAME }" class="ui button" style="position: absolute; right: 10px; bottom: 10px;" onclick="{ toggle }">
        Show research menu
    </button>
    <div class="ui grid" show="{ show_research_menu }">
        <div class="ui row">
            <div class="ui sixteen wide column segment">
                <div class="ui top attached tabular menu">
                    <a each="{ category in research_menu }" class="item" data-tab="{ category.key }">{ category.name }</a>
                </div>
                <div each="{ category in research_menu }" class="ui bottom attached tab segment" data-tab="{ category.key }">
                    <ul>
                        <li each="{ thing in category }">{ thing }</li>
                    </ul>
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

            $('.menu .item').tab()

            var enter_test_mode = function () {
                self.show_scoreboard = true
                window.researchMenu = {
                    update: function () {
                        return JSON.stringify({
                            "armor": {
                                "techs": {
                                    "armor_two": {
                                        "votes": 0.0,
                                        "reqs": [
                                            "Armor Type I"
                                        ],
                                        "description": "Decent Armor (40)",
                                        "key": "armor_two",
                                        "name": "Armor Type II",
                                        "cost": 65.0
                                    },
                                    "armor_three": {
                                        "votes": 0.0,
                                        "reqs": [
                                            "Armor Type II"
                                        ],
                                        "description": "Better Armor (60)",
                                        "key": "armor_three",
                                        "name": "Armor Type III",
                                        "cost": 70.0
                                    },
                                    "armor_one": {
                                        "votes": 0.0,
                                        "reqs": [],
                                        "description": "Light Armor (20)",
                                        "key": "armor_one",
                                        "name": "Armor Type I",
                                        "cost": 60.0
                                    },
                                    "armor_four": {
                                        "votes": 0.0,
                                        "reqs": [
                                            "Armor Type III"
                                        ],
                                        "description": "Good Armor",
                                        "key": "armor_four",
                                        "name": "Armor Type IV",
                                        "cost": 75.0
                                    },
                                    "armor_five": {
                                        "votes": 0.0,
                                        "reqs": [
                                            "Armor Type IV"
                                        ],
                                        "description": "Best Armor",
                                        "key": "armor_five",
                                        "name": "Armor Type V",
                                        "cost": 75.0
                                    }
                                },
                                "key": "armor",
                                "name": "Armor"
                            },
                            "health": {
                                "techs": {
                                    "health_three": {
                                        "votes": 0.0,
                                        "reqs": [
                                            "Health Type II"
                                        ],
                                        "description": "Better Health (60)",
                                        "key": "health_three",
                                        "name": "Health Type III",
                                        "cost": 70.0
                                    },
                                    "health_five": {
                                        "votes": 0.0,
                                        "reqs": [
                                            "Health Type IV"
                                        ],
                                        "description": "Best Armor",
                                        "key": "health_five",
                                        "name": "Health Type V",
                                        "cost": 75.0
                                    },
                                    "health_one": {
                                        "votes": 0.0,
                                        "reqs": [],
                                        "description": "Light Health (20)",
                                        "key": "health_one",
                                        "name": "Health Type I",
                                        "cost": 60.0
                                    },
                                    "health_four": {
                                        "votes": 0.0,
                                        "reqs": [
                                            "Health Type III"
                                        ],
                                        "description": "Good Armor",
                                        "key": "health_four",
                                        "name": "Health Type IV",
                                        "cost": 75.0
                                    },
                                    "health_two": {
                                        "votes": 0.0,
                                        "reqs": [
                                            "Health Type I"
                                        ],
                                        "description": "Decent Health (40)",
                                        "key": "health_two",
                                        "name": "Health Type II",
                                        "cost": 65.0
                                    }
                                },
                                "key": "health",
                                "name": "Health"
                            }
                        })
                    }
                }
            }

            if (!IS_IN_GAME) {
                enter_test_mode()
            }
        })

        /**********************************************************************
         * Methods
         *********************************************************************/
        var update_loop = function () {
            // player may not exist if we're testing in local browser, wait for it
            if (typeof researchMenu !== 'undefined' && typeof researchMenu.update === 'function') {
                var temp_result = researchMenu.update()
                if (temp_result !== null && typeof temp_result !== 'undefined') {
                    //console.log(temp_result)
                    self.update({
                        research_menu: JSON.parse(temp_result),
                    })
                }

                window.setTimeout(update_loop, 25);
            }
        }

        self.toggle = function() {
            self.show_research_menu = !self.show_research_menu
            self.update()
        }

        /**********************************************************************
         * Events
         *********************************************************************/
        EVENTS.on('toggle_research_menu', self.toggle)
    </script>
    <style scoped>
    </style>
</research-menu>