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

        $items = acona_get_data($token);

        include $templatePath;
    }

}

function acona_get_data($token){

    if ( false === ( $items = get_transient( 'acona_data' ) ) ) {

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

        set_transient( 'acona_data', $items, 12 * HOUR_IN_SECONDS );
    }

    return $items;

}

function acona_dashboard_widget_options(){

    $options = wp_parse_args(
        get_option( 'acona_settings' ),
        [
            'token' => '',
            'domain' => get_site_url()
        ]
    );

    if ( isset( $_POST['submit'] ) ) {
        if ( isset( $_POST['acona_token'] ) ) {
            $options['token'] = esc_attr($_POST['acona_token']);
        }
        if ( isset( $_POST['acona_domain'] ) ) {
            $options['domain'] = esc_attr($_POST['acona_domain']);
        }

        update_option( 'acona_settings', $options );
    }

    ?>
    <p>
        <label><?php _e( 'Token', 'acona' ); ?>
            <input type="text" name="acona_token" value="<?php echo esc_attr( $options['token'] ); ?>" />
        </label>
    </p>
    <p>
        <label><?php _e( 'Domain', 'acona' ); ?>
            <input type="text" name="acona_domain" value="<?php echo esc_attr( $options['domain'] ); ?>" />
        </label>
    </p>
    <?php
}