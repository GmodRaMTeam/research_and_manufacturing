<scoreboard>

    <!--<div class="ui middle aligned center aligned grid">-->
        <!--<div class="column">-->
            <!--<h2 class="ui teal image header">-->
                <!--<img src="images/logo.png" class="image">-->
                <!--&lt;!&ndash;<div class="content">&ndash;&gt;-->
                    <!--&lt;!&ndash;Log-in to your account&ndash;&gt;-->
                <!--&lt;!&ndash;</div>&ndash;&gt;-->
            <!--</h2>-->
            <!--<form class="ui large form">-->
                <!--<div class="ui stacked segment">-->
                    <!--<table class="ui table">-->
                        <!--<thead>-->
                            <!--<th>Something</th>-->
                            <!--<th>Something</th>-->
                            <!--<th>Something</th>-->
                        <!--</thead>-->
                        <!--<tbody>-->
                            <!--<td>Something</td>-->
                            <!--<td>Something</td>-->
                            <!--<td>Something</td>-->
                        <!--</tbody>-->
                    <!--</table>-->
                    <!--&lt;!&ndash;<div class="field">&ndash;&gt;-->
                        <!--&lt;!&ndash;<div class="ui left icon input">&ndash;&gt;-->
                            <!--&lt;!&ndash;<i class="user icon"></i>&ndash;&gt;-->
                            <!--&lt;!&ndash;<input type="text" name="email" placeholder="E-mail address">&ndash;&gt;-->
                        <!--&lt;!&ndash;</div>&ndash;&gt;-->
                    <!--&lt;!&ndash;</div>&ndash;&gt;-->
                    <!--&lt;!&ndash;<div class="field">&ndash;&gt;-->
                        <!--&lt;!&ndash;<div class="ui left icon input">&ndash;&gt;-->
                            <!--&lt;!&ndash;<i class="lock icon"></i>&ndash;&gt;-->
                            <!--&lt;!&ndash;<input type="password" name="password" placeholder="Password">&ndash;&gt;-->
                        <!--&lt;!&ndash;</div>&ndash;&gt;-->
                    <!--&lt;!&ndash;</div>&ndash;&gt;-->
                    <!--&lt;!&ndash;<div class="ui fluid large teal submit button">Login</div>&ndash;&gt;-->
                <!--</div>-->

                <!--&lt;!&ndash;<div class="ui error message"></div>&ndash;&gt;-->

            <!--</form>-->

            <!--&lt;!&ndash;<div class="ui message">&ndash;&gt;-->
                <!--&lt;!&ndash;New to us? <a href="#">Sign Up</a>&ndash;&gt;-->
            <!--&lt;!&ndash;</div>&ndash;&gt;-->
        <!--</div>-->
    <!--</div>-->

    <!--<div class="ui centered grid">-->
        <!--<div class="container">-->
            <!--<table class="ui table">-->
                <!--<tr class="row">-->
                <!--<th>Something</th>-->
                <!--<th>Something</th>-->
                <!--<th>Something</th>-->
                <!--</tr>-->
                <!--<tr each="{ player in player_list }" class="">-->
                    <!--<td>-->
                        <!--{player.nick}-->
                    <!--</td>-->
                    <!--<td>-->
                        <!--{player.frags}-->
                    <!--</td>-->
                    <!--<td>-->
                        <!--{player.deaths}-->
                    <!--</td>-->
                <!--</tr>-->
            <!--</table>-->
        <!--</div>-->
    <!--</div>-->

    <table class="ui striped table">
        <tr class="row">
            <th>
                <div class="ui large yellow label">
                    <i class="pencil icon"></i>
                    Name
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
        </tr>
        <!--<tr each="{ player in player_list }" class="">-->
            <!--<td>-->
                <!--{player.nick}-->
            <!--</td>-->
            <!--<td>-->
                <!--{player.frags}-->
            <!--</td>-->
            <!--<td>-->
                <!--{player.deaths}-->
            <!--</td>-->
        <!--</tr>-->
    </table>

    <script>
        var self = this;

        self.on('mount', function() {
            update_loop();
        })


        var update_loop = function() {
//            self.player_list = JSON.parse(player.getAll());
            self.update({
                team_list: JSON.parse(player.getAll()),
            })
            window.setTimeout(update_loop, 1000);
        }
    </script>
</scoreboard>