<table style="width: 100%">
    <thead>
        <tr>
            <th style="text-align: left"><?php _e('URL', 'acona'); ?></th>
            <th style="text-align: left"><?php _e('Score', 'acona'); ?></th>
        </tr>
    </thead>
    <?php foreach ($items as $item): ?>
        <tr>
            <td>
                <a href="<?php echo esc_url($item->url); ?>">
                    <?php echo esc_url($item->url); ?>
                </a>
            </td>
            <td>
                <?php echo esc_html($item->value); ?>
            </td>
        </tr>
    <?php endforeach; ?>
</table>