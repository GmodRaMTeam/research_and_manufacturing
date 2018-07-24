<scoreboard>

    <div each="{ team in teams }" no-reorder>
        <h1 class="scoreboard-title">{team.name} ({team.score} pts)</h1>
        <table class="ui striped table">
            <thead>
            <tr>
                <th>
                    <div class="ui large">
                        <i class="pencil icon"></i>
                        Name
                    </div>
                </th>
                <th>
                    <div class="ui large">
                        <i class="address card icon"></i>
                        SteamID
                    </div>
                </th>
                <th>
                    <div class="ui large">
                        <i class="shield alternate icon"></i>
                        Kills
                    </div>
                </th>
                <th>
                    <div class="ui large">
                        <i class="ambulance icon"></i>
                        Deaths
                    </div>
                </th>
                <th>
                    <div class="ui large">
                        <i class="computer icon"></i>
                        Ping
                    </div>
                </th>
            </tr>
            </thead>
            <tbody>
            <tr each="{ player in team.team_members }" class="">
                <td>
                    {player.nick}
                </td>
                <td>
                    {player.steamid}
                </td>
                <td>
                    {player.frags}
                </td>
                <td>
                    {player.deaths}
                </td>
                <td>
                    {player.ping}
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <script>
        var self = this;

        self.on('mount', function () {
            update_loop();
        })


        var update_loop = function () {
            // player may not exist if we're testing in local browser, wait for it
            if (typeof player !== 'undefined') {
                self.update({
                    teams: JSON.parse(player.getAll()),
                })
            }
            window.setTimeout(update_loop, 1000);
        }
    </script>
    <style scoped>
        .scoreboard-title {
            margin: 20px 0 !important;
            color: #efefef;
        }
    </style>
</scoreboard>