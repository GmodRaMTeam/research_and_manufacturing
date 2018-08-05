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

    <!--<div show="{show_scientist}" id="icon-container">-->
        <!--<i class="ui massive inverted user secret icon"></i>-->
        <!--&lt;!&ndash;<img show="{show_scientist}" id="icon-container" src="images/icons8-detective-64.png">&ndash;&gt;-->
    <!--</div>-->
    <h2 show="{show_scientist}" class="ui small inverted icon header" id="icon-container">
        <!--<i class="settings icon"></i>-->
        <i class="user secret icon"></i>
        <div class="content">
            You Have
            <div class="sub header">A Scientist</div>
        </div>
    </h2>

    <!--<div show="{show_voting_status}" id="voting-container">-->
        <!--<i show="{player_data.status === 1}" class="ui huge inverted cogs icon"></i>-->
        <!--<i show="{player_data.status === 2}" class="ui huge inverted file alternate icon"></i>-->
        <!--<i show="{player_data.status === 3}" class="ui huge inverted ellipsis horizontal icon"></i>-->
        <!--&lt;!&ndash;<img show="{show_scientist}" id="icon-container" src="images/icons8-detective-64.png">&ndash;&gt;-->
    <!--</div>-->
    <h2 class="ui small inverted icon header" id="voting-container">
        <!--<i class="settings icon"></i>-->
        <i show="{player_data.status === 1}" class="cogs icon"></i>
        <i show="{player_data.status === 2}" class="file alternate icon"></i>
        <i show="{player_data.status === 3}" class="ellipsis horizontal icon"></i>
        <div class="content">
            Status
            <div show="{player_data.status === 1}" class="sub header">Researching</div>
            <div show="{player_data.status === 2}" class="sub header">Voting</div>
            <div show="{player_data.status === 3}" class="sub header">Waiting</div>
        </div>
    </h2>

    <h2 class="ui small inverted icon header" id="scientist-container">
        <!--<i class="settings icon"></i>-->
        <i class="users icon"></i>
        <div class="content">
            Scientists
            <div class="sub header">{player_data.team_scientist_count}</div>
        </div>
    </h2>

    <!--<div show="{show_voting_status}" id="voting-container">-->
        <!--<i class="ui massive inverted file alternate icon"></i>-->
        <!--&lt;!&ndash;<img show="{show_scientist}" id="icon-container" src="images/icons8-detective-64.png">&ndash;&gt;-->
    <!--</div>-->


    <div id="health-container">
        <div class="progress-bar-icon">
            <i class="plus alternate icon"></i>
        </div>
        <div class="ui indicating green progress" id="health">
            <div class="bar">
                <div class="progress"></div>
            </div>
        </div>
    </div>

    <div id="armor-container">
        <div class="progress-bar-icon">
            <i class="shield alternate icon"></i>
        </div>
        <div class="ui indicating warning progress" id="armor">
            <div class="bar">
                <div class="progress"></div>
            </div>
        </div>
    </div>


    <script>
        var self = this
        self.player_data = {
            health: 100,
            armor: 100
        }
        self.show_scientist = false
        self.show_voting_status = true

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
                            armor: 100,
                            has_scientist: true
                        })
                    }
                }
            }

            // start recurring update loop
            update_loop()
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
                var result = player.getInfo()
                if (result !== null && typeof result !== 'undefined') {
                    self.player_data = JSON.parse(result)
                    self.set_progress_bars(self.player_data)
                    if (self.player_data['has_scientist'] === true) {
                        self.show_scientist = true
                    } else {
                        self.show_scientist = false
                    }
                    // if (self.player_data['status'] === 2) {
                    //     self.show_voting_status = true
                    // } else {
                    //     self.show_voting_status = false
                    // }
                    self.update()
                }
            }
            window.setTimeout(update_loop, 25)
        }
    </script>
    <style scoped>
        #health-container .icon {
            position: absolute;
            top: -92px;
            left: 3px;
        }

        #health {
            position: absolute;
            left: 28px;
            bottom: 50px;
            right: 0;
        }

        #armor-container .icon {
            position: absolute;
            top: -43px;
            left: 3px;
        }

        #armor {
            position: absolute;
            left: 28px;
            bottom: 0;
            right: 0;
        }
        #armor .bar {
            background-color: gold !important;
        }

        .ui.progress {
            background: rgba(0, 0, 0, .03);
        }

        .header-text {
            color: #b1b1b1 !important;
        }

        .progress-bar-icon {
            /*display: inline-block;*/
            font-size: 20px;
            /*margin-top: 3px;*/
            color: #b1b1b1;
        }

        .bar .progress {
            /* Hide % text in progress bar */
            font-size: 0 !important;
        }

        #icon-container {
            position: fixed;
            bottom: 45%;
            left: 0px;

            /*left: 3px;*/
        }

        #voting-container {
            position: fixed;
            bottom: 0;
            left: 30%;
            /*right: 50%;*/

            /*left: 3px;*/
        }

        #scientist-container {
            position: fixed;
            bottom: 0;
            right: 20%;
            /*right: 50%;*/

            /*left: 3px;*/
        }
        /*https://icons8.com/icon/set/secret/all*/
    </style>
</health-and-armor>
