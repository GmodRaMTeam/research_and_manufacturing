<health-and-armor>
    <!-- Health -->
    <div class="ui active inverted small red progress" id="health">
        <div class="bar">
            <div class="progress"></div>
        </div>
        <div class="label header-text">Health</div>
    </div>
    <div class="ui active inverted small blue progress" id="armor">
        <div class="bar">
            <div class="progress"></div>
        </div>
        <div class="label header-text">Armor</div>
    </div>
    <script>
        var self = this

        self.on('mount', function () {
            // start recurring update loop
            update_loop()

            // Initialize progress bars
            $('#health')
                .progress()
            $('#armor')
                .progress()
        })

        var update_loop = function () {
            if (typeof player !== 'undefined' && typeof player.getInfo !== 'undefined') {
                self.update({
                    player_data: JSON.parse(player.getInfo()),
                })
                $('#health').progress(
                    'set progress',
                    self.player_data.health
                )
                $('#armor').progress(
                    'set progress',
                    self.player_data.armor
                )
            }
            window.setTimeout(update_loop, 25)
        }
    </script>
</health-and-armor>
