<?php
/**
* Plugin Name: acona
* Description: WordPress plugin for acona.
*/

add_action( 'wp_dashboard_setup', function () {
    wp_add_dashboard_widget(
        'acona_dashboard_widget',
        __( 'Acona', 'acona' ),
        'acona_dashboard_widget',
        'acona_dashboard_widget_options'
    );
} );

function acona_dashboard_widget() {

    $templatePath = implode(
        '',
        [
            plugin_dir_path(__FILE__),
            'templates',
            '/dashboard_widget.php',
        ]
    );

    if (file_exists($templatePath)) {

        $settings = get_option( 'acona_settings' );
        if(empty($settings['token'])){
            return __('Missing token', 'acona');
        }
        $token = esc_attr($settings['token']);

        $apiResponse = wp_remote_get(
            'https://data.acona.app/rpc/acona_urls_success',
            [
                'method' => 'POST',
                'headers' => [
                    'Authorization' => 'Bearer ' . $token
                ],
                'body' => [
                    'domain' => 'https://www.acona.app'
                ]
            ]
        );

        $items = json_decode($apiResponse['body']);

        include $templatePath;
    }

}

function acona_dashboard_widget_options(){

    $options = wp_parse_args(
        get_option( 'acona_settings' ),
        [ 'token' => '']
    );

    if ( isset( $_POST['submit'] ) ) {
        if ( isset( $_POST['acona_token'] ) ) {
            $options['token'] = esc_attr($_POST['acona_token']);
        }

        update_option( 'acona_settings', $options );
    }

    ?>
    <p>
        <label><?php _e( 'Acona token', 'acona' ); ?>
            <input type="text" name="acona_token" value="<?php echo esc_attr( $options['token'] ); ?>" />
        </label>
    </p>
    <?php
}