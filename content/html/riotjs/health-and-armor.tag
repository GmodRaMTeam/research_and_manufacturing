<health-and-armor>
    <button show="{ !IS_IN_GAME }" class="ui button" style="position: absolute; right: -180px; bottom: 32px;" onclick="{ randomness }">
        Random hp/armor?
    </button>

    <!-- Health -->
    <!--<div class="ui indicating green progress" id="health">-->
        <!--<div class="bar">-->
            <!--<div class="progress"></div>-->
        <!--</div>-->
        <!--&lt;!&ndash;<div class="label header-text">Health</div>&ndash;&gt;-->
    <!--</div>-->


    <div class="ui grid" id="health-container">
        <div class="two wide column">
            <div class="progress-bar-icon">
                <i class="plus alternate icon"></i>
            </div>
        </div>
        <div class="thirteen wide column">
            <div class="ui indicating green progress" id="health">
                <div class="bar">
                    <div class="progress"></div>
                </div>
                <!--<div class="label header-text">Armor</div>-->
            </div>
        </div>
    </div>

    <div class="ui grid">
        <div class="three wide column">
            <div class="progress-bar-icon">
                <i class="shield alternate icon"></i>
            </div>
        </div>
        <div class="thirteen wide column">
            <div class="ui indicating warning progress" id="armor">
                <div class="bar">
                    <div class="progress"></div>
                </div>
                <!--<div class="label header-text">Armor</div>-->
            </div>
        </div>
    </div>


    <script>
        var self = this
        self.player_data = {
            health: 100,
            armor: 100
        }

        /**********************************************************************
         * Init
         *********************************************************************/
        self.one('mount', function () {
            // Initialize progress bars
            $('#health', '#armor').progress({
                value: 100,
                total: 100,
                autoSuccess: false,
                showActivity: false,
                label: 'percent'
            })

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

        self.randomness = function () {
            self.set_progress_bars({
                health: Math.random() * 100,
                armor: Math.random() * 100
            })
        }

        self.set_progress_bars = function (data) {
            // Split this out into a separate function so we could set progress bars
            // from random or from player info
            $('#health').progress(
                'update progress',
                data.health
            )
            $('#armor').progress(
                'update progress',
                data.armor
            )
        }

        /**********************************************************************
         * Methods
         *********************************************************************/
        var update_loop = function () {
            if (typeof player !== 'undefined' && typeof player.getInfo !== 'undefined') {
                self.player_data = JSON.parse(player.getInfo())
                self.set_progress_bars(self.player_data)

            }
            window.setTimeout(update_loop, 25)
        }
    </script>
    <style scoped>
        #health-container {
            /* Line up the health bar on top of the armor bar */
            margin-bottom: -4rem;
        }

        .header-text {
            color: #b1b1b1 !important;
        }

        .progress-bar-icon {
            display: inline-block;
            font-size: 20px;
            margin-top: 3px;
            color: #b1b1b1;
        }
    </style>
</health-and-armor>
