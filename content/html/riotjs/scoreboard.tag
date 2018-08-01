<scoreboard show="{ show_scoreboard }">

    <div each="{ team in teams }" no-reorder>
        <h1 class="header-text scoreboard-title">{team.name} ({team.score} pts)</h1>
        <table class="ui striped table">
            <thead>
            <tr>
                <th class="ui large"><i class="pencil icon"></i>Name</th>
                <th class="ui large address-column" align="right"><i class="address card icon"></i>SteamID</th>
                <th class="ui large number-column"><i class="shield alternate icon"></i>Kills</th>
                <th class="ui large number-column"><i class="ambulance icon"></i>Deaths</th>
                <th class="ui large number-column"><i class="computer icon"></i>Ping</th>
            </tr>
            </thead>
            <tbody>
            <tr show="{ team.team_members.length == 0}">
                <td class="cowards" colspan="5">No cowards available</td>
            </tr>
            <tr each="{ player in team.team_members }" class="">
                <td>{ player.nick }</td>
                <td class="address-column">{ player.steamid }</td>
                <td class="number-column">{ player.frags }</td>
                <td class="number-column">{ player.deaths }</td>
                <td class="number-column">{ player.ping }</td>
            </tr>
            </tbody>
        </table>
    </div>

    <script>
        var self = this;
        self.show_scoreboard = false

        /**********************************************************************
         * Init
         *********************************************************************/
        self.on('mount', function () {
            update_loop();

            var enter_test_mode = function () {
                self.show_scoreboard = true
                window.player = {
                    getAll: function () {
                        return JSON.stringify([{
                            name: "Oj",
                            score: "0",
                            team_members: [{
                                nick: "Testerino",
                                steamid: "0:0:123321313",
                                frags: 0,
                                deaths: 0,
                                ping: 20
                            }]
                        }, {
                            name: "Blue with some words",
                            score: "0",
                            team_members: [{
                                nick: "Testerino",
                                steamid: "123asdf",
                                frags: 0,
                                deaths: 0,
                                ping: 43
                            }]
                        }])
                    }
                }
            }

            if(!IS_IN_GAME) {
                enter_test_mode()
            }
        })

        /**********************************************************************
         * Methods
         *********************************************************************/
        var update_loop = function () {
            // player may not exist if we're testing in local browser, wait for it
            if (typeof player !== 'undefined' && typeof player.getAll !== 'undefined') {
                self.update({
                    teams: JSON.parse(player.getAll()),
                })
            }
            window.setTimeout(update_loop, 25);
        }

        /**********************************************************************
         * Events
         *********************************************************************/
        EVENTS.on('show_scoreboard', function() {
            self.show_scoreboard = true
            self.update()
        })

        EVENTS.on('hide_scoreboard', function() {
            self.show_scoreboard = false
            self.update()
        })
    </script>
    <style scoped>
        .scoreboard-title {
            margin: 20px 0 !important;
            color: #efefef;
        }

        .address-column {
            max-width: 175px;
            min-width: 175px;
            width: 175px;
        }

        .number-column {
            text-align: center !important;
            width: 125px;
        }

        .cowards {
            font-style: italic;
            text-align: center !important;
        }
    </style>
</scoreboard>