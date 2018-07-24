<hud-health>
    <!--<div class="ui inverted segment">-->
        <div class="ui active inverted small red progress" id="health">
            <div class="bar">
                <div class="progress"></div>
            </div>
            <div class="label">Health</div>
        </div>
        <div class="ui active inverted small blue progress" id="armor">
            <div class="bar">
                <div class="progress"></div>
            </div>
            <div class="label">Armor</div>
        </div>
    <!--</div>-->
    <script>
        var self = this;

        self.on('mount', function () {
            update_loop();
            $('#health')
                .progress()
            ;
            $('#armor')
                .progress()
            ;

        })


        var update_loop = function () {
//            self.player_list = JSON.parse(player.getAll());
//             var player_data = JSON.parse(player.getInfo());
            self.update({
                player_data: JSON.parse(player.getInfo()),
            })
            // $('.progress').progress('set progress', progress);
            $('#health').progress(
                'set progress',
                self.player_data.health
            );
            $('#armor').progress(
                'set progress',
                self.player_data.armor
            );
            // console.log(self.team_list)
            window.setTimeout(update_loop, 250);
        }
    </script>
</hud-health>