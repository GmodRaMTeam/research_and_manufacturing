<scoreboard>
        <table each="{ team in team_list }" class="ui striped table">
            <tr>
                <th>Team: {team.name}</th>
                <th>Score: {team.score}</th>
            </tr>
            <tr>
                <th>
                    <div class="ui large yellow label">
                        <i class="pencil icon"></i>
                        Name
                    </div>
                </th>
                <th>
                    <div class="ui large yellow label">
                        <i class="address card icon"></i>
                        SteamID
                    </div>
                </th>
                <th>
                    <div class="ui large blue label">
                        <i class="shield alternate icon"></i>
                        Kills
                    </div>
                </th>
                <th>
                    <div class="ui large red label">
                        <i class="ambulance icon"></i>
                        Deaths
                    </div>
                </th>
                <th>
                    <div class="ui large teal label">
                        <i class="computer icon"></i>
                        Ping
                    </div>
                </th>
            </tr>
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
        </table>

    <script>
        var self = this;

        self.on('mount', function () {
            update_loop();
        })


        var update_loop = function () {
//            self.player_list = JSON.parse(player.getAll());
            self.update({
                team_list: JSON.parse(player.getAll()),
            })
            // console.log(self.team_list)
            window.setTimeout(update_loop, 1000);
        }
    </script>
</scoreboard>