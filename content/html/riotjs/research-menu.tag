<research-menu>
    <button show="{ !IS_IN_GAME }" class="ui button" style="position: absolute; right: 10px; bottom: 10px;"
            onclick="{ toggle }">
        Research menu?
    </button>
    <div id="MAIN" class="" show="{ show_research_menu }">
        <div class="ui bottom attached segment pushable">
            <div class="ui visible inverted left vertical sidebar menu">
                <a each="{category in categories}" onclick="{ toggle_key.bind(this, category.key) }" class="item">
                    <i class="home icon"></i>
                    {category.name}
                </a>
            </div>
            <div class="pusher">
                <div id="no-margin" each="{category in categories}" show="{ show[category.key] }"
                     class="ui basic segment">
                    <h1 class="ui centered header" style="margin-left: -13% !important;">{category.name}</h1>
                    <div class="ui horizontal divider"></div>
                    <!--<button each="{tech in category.techs}" class="ui button" onclick="{ record_vote.bind(this, category.key, tech.key) }">{tech.name}</button>-->
                    <div class="ui grid">
                        <table class="ui table" style="width: 90%;">
                            <tr>
                                <th>
                                    Name
                                </th>
                                <th>
                                    Description
                                </th>
                                <th>
                                    Requirements
                                </th>
                                <th>
                                    Action
                                </th>
                            </tr>
                            <tr each="{tech in category.techs}">
                                <td>
                                    {tech.name}
                                </td>
                                <td>
                                    {tech.description}
                                </td>
                                <td>
                                    {tech.reqs}
                                </td>
                                <td>
                                    <button class="ui blue button {disabled: !tech.can_research}" onclick="{ record_vote.bind(this, category.key, tech.key) }">
                                        Vote
                                    </button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var self = this;
        self.show_research_menu = false
        self.tabs_inited = false
        self.show_armor = false
        self.show = {}
        // self.categories = []
        self.CAT_NAME_ARMOR = 'armor'

        /**********************************************************************
         * Init
         *********************************************************************/
        self.one('mount', function () {
            // update_loop();

            // $('.menu .item').tab()
            // $('.tabular.menu .item').tab();
            $('.tabular.menu .item').tab();

            if (!IS_IN_GAME) {
                window.researchMenu = {
                    update: function () {
                        return JSON.stringify([{
                            "techs": [{
                                "votes": 0,
                                "cost": 60,
                                "reqs": [],
                                "key": "armor_one",
                                "tier": 1,
                                "name": "Armor Type I",
                                "description": "Light Armor (20)"
                            }, {
                                "votes": 0,
                                "cost": 65,
                                "reqs": ["Armor Type I"],
                                "key": "armor_two",
                                "tier": 2,
                                "name": "Armor Type II",
                                "description": "Decent Armor (40)"
                            }, {
                                "votes": 0,
                                "cost": 70,
                                "reqs": ["Armor Type II"],
                                "key": "armor_three",
                                "tier": 3,
                                "name": "Armor Type III",
                                "description": "Better Armor (60)"
                            }, {
                                "votes": 0,
                                "cost": 75,
                                "reqs": ["Armor Type III"],
                                "key": "armor_four",
                                "tier": 4,
                                "name": "Armor Type IV",
                                "description": "Good Armor"
                            }, {
                                "votes": 0,
                                "cost": 75,
                                "reqs": ["Armor Type IV"],
                                "key": "armor_five",
                                "tier": 5,
                                "name": "Armor Type V",
                                "description": "Best Armor"
                            }], "key": "armor", "name": "Armor"
                        }, {
                            "techs": [{
                                "votes": 0,
                                "cost": 60,
                                "reqs": [],
                                "key": "health_one",
                                "tier": 1,
                                "name": "Health Type I",
                                "description": "Light Health (20)"
                            }, {
                                "votes": 0,
                                "cost": 65,
                                "reqs": ["Health Type I"],
                                "key": "health_two",
                                "tier": 2,
                                "name": "Health Type II",
                                "description": "Decent Health (40)"
                            }, {
                                "votes": 0,
                                "cost": 70,
                                "reqs": ["Health Type II"],
                                "key": "health_three",
                                "tier": 3,
                                "name": "Health Type III",
                                "description": "Better Health (60)"
                            }, {
                                "votes": 0,
                                "cost": 75,
                                "reqs": ["Health Type III"],
                                "key": "health_four",
                                "tier": 4,
                                "name": "Health Type IV",
                                "description": "Good Armor"
                            }, {
                                "votes": 0,
                                "cost": 75,
                                "reqs": ["Health Type IV"],
                                "key": "health_five",
                                "tier": 5,
                                "name": "Health Type V",
                                "description": "Best Armor"
                            }], "key": "health", "name": "Health"
                        }])
                    }
                }
            }
        })

        /**********************************************************************
         * Methods
         *********************************************************************/
        // self.fun_show_armor = function() {
        //     self.update({show_armor: true})
        // }
        //
        // self.fun_hide_armor = function() {
        //     self.update({show_armor: false})
        // }

        self.toggle_key = function (cat_key) {
            // self['show_' + cat_key] = true
            self.reset_shown(cat_key)
            self.show[cat_key] = !self.show[cat_key]
            self.update()
        }

        self.reset_shown = function (cat_key) {
            for (var key in self.show) {
                console.log("Key: " + key + " in self.show")
                // check if the property/key is defined in the object itself, not in parent
                if (self.show.hasOwnProperty(key)) {
                    if (cat_key !== key && self.show[key] === true) {
                        // console.log(key, dictionary[key]);
                        self.show[key] = false
                    }
                }
            }
        }

        self.record_vote = function (cat_key, tech_key) {
            console.log("This got called")
            // check if the property/key is defined in the object itself, not in parent
            console.log(cat_key)
            console.log(tech_key)
            // console.log(key, dictionary[key]);
            // self.show[key] = false
            vote.send(cat_key, tech_key)


        }

        // self.hide_key = function (cat_key) {
        //     // self['show_' + cat_key] = false
        //     self.show[cat_key] = false
        //     self.update()
        // }

        /*self.get_cat = function (cat_key) {
            console.log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
            return self['show_' + cat_key]
        }*/
        //
        // var update_loop = function () {
        //     // player may not exist if we're testing in local browser, wait for it
        //     if (typeof researchMenu !== 'undefined' && typeof researchMenu.update === 'function') {
        //         var temp_result = researchMenu.update()
        //         if (temp_result !== null && typeof temp_result !== 'undefined') {
        //             // console.log(temp_result)
        //             // self.update({
        //             //     categories: JSON.parse(temp_result),
        //             // })
        //             self.categories = JSON.parse(temp_result)
        //             console.log(self.categories)
        //             self.categories.forEach(function (arrayItem) {
        //                 arrayItem.techs.sort(function (a, b) {
        //                     return a.tier > b.tier
        //                 })
        //             })
        //             self.update()
        //
        //
        //             // self.tabs_inited = true
        //
        //             console.log(JSON.stringify(self.categories))
        //         }
        //     }
        //     window.setTimeout(update_loop, 250);
        // }

        self.toggle = function () {
            self.show_research_menu = !self.show_research_menu
            if (self.show_research_menu === true) {
                if (typeof researchMenu !== 'undefined' && typeof researchMenu.update === 'function') {
                var temp_result = researchMenu.update()
                if (temp_result !== null && typeof temp_result !== 'undefined') {
                    self.categories = JSON.parse(temp_result)
                    self.categories.forEach(function (arrayItem) {
                        arrayItem.techs.sort(function (a, b) {
                            return a.tier > b.tier
                        })
                    })
                    self.update()

                    console.log(JSON.stringify(self.categories))
                }
            }
            }
            self.update()
        }

        /**********************************************************************
         * Events
         *********************************************************************/
        EVENTS.on('toggle_research_menu', self.toggle)
        // EVENTS.on('toggle_research_menu', self.toggle)
    </script>
    <style scoped>
        #MAIN {
            height: 80%;
            /*min-height: 80%;*/
            /*max-height: 80%;*/
        }

        #no-margin {
            margin: 0 !important;
        }
    </style>
</research-menu>