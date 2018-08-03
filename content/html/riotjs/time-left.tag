<time-left>
    <!--<button show="{ !IS_IN_GAME }" class="ui button" style="position: absolute; right: -180px; bottom: 32px;" onclick="{ randomness }">-->
        <!--Random hp/armor?-->
    <!--</button>-->
    <div>
        <!--<i class="clock outline icon"></i>-->
        <h2 class="ui inverted icon header">
            <!--<i class="settings icon"></i>-->
            <i class="clock outline icon"></i>
            <div show="{show_map}" class="content">
                {time_data[CONST_MAP]}
                <div show="{show_prep}" class="sub header">{time_data[CONST_PREP]}</div>
            </div>
        </h2>
    </div>

    <script>
        var self = this

        self.time_data = {
            map: 53.57,
            prep: 15.93,
        }

        self.show_map = true
        self.show_prep = true

        self.CONST_MAP = "map"
        self.CONST_PREP = "prep"

        /**********************************************************************
         * Init
         *********************************************************************/
        self.one('mount', function () {
            if (!IS_IN_GAME) {
                // Test mode!
                window.player = {
                    getInfo: function () {
                        return JSON.stringify({
                            health: 100,
                            armor: 100
                        })
                    }
                }
            }

            // start recurring update loop
            console.log('before')
            update_loop()
            console.log('after')
        })


        /**********************************************************************
         * Methods
         *********************************************************************/
        var update_loop = function () {
            if (typeof time !== 'undefined' && typeof time.left !== 'undefined') {
                var result = time.left()
                if (result !== null && typeof result !== 'undefined') {
                    self.time_data = JSON.parse(result)
                    // self.set_progress_bars(self.player_data)
                    // if (result['map'] > 0) {
                    //     self.show_map = true
                    // } else{
                    //     self.show_map = false
                    // }
                    //
                    // if (result['prep'] > 0) {
                    //     self.show_prep = true
                    // } else{
                    //     self.show_prep = false
                    // }
                    self.update()
                    // console.log(result)
                }
            }
            window.setTimeout(update_loop, 25)
        }
    </script>
    <style scoped>
    </style>
</time-left>
