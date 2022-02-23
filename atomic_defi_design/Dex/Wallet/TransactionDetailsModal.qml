import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Qaterial 1.0 as Qaterial

import "../Components"
import "../Constants"
import App 1.0
import Dex.Themes 1.0 as Dex

// Open Transaction Details Modal
MultipageModal
{
    id: root

    function reset() { }

    property var details

    onClosed:
    {
        if (notes.field.enabled) notes.save_button.clicked()
        details = undefined
    }

    MultipageModalContent
    {
        titleText: qsTr("Transaction Details")

        // Amount
        TextEditWithTitle
        {
            title: qsTr("Amount")
            text: !details ? "" : General.formatCrypto(!details.am_i_sender, details.amount, api_wallet_page.ticker, details.amount_fiat, API.app.settings_pg.current_currency)
            value_color: !details ? "white" : details.am_i_sender ?  DexTheme.redColor : DexTheme.greenColor
            privacy: true
        }

        // Fees
        TextEditWithTitle
        {
            title: qsTr("Fees")
            text: !details ? "" : General.formatCrypto(parseFloat(details.fees) < 0, Math.abs(parseFloat(details.fees)), current_ticker_infos.fee_ticker, details.fees_amount_fiat, API.app.settings_pg.current_currency)
            value_color: !details ? "white" : parseFloat(details.fees) > 0 ? DexTheme.redColor : DexTheme.greenColor
            privacy: true
        }

        // Date
        TextEditWithTitle
        {
            title: qsTr("Date")
            text: !details ? "" : details.timestamp === 0 ? qsTr("Unconfirmed"):  details.date
        }

        // Transaction Hash
        TextEditWithTitle
        {
            id: txHash
            title: qsTr("Transaction Hash")
            text: !details ? "" : details.tx_hash
            privacy: true
            copy: true

            onCopyNotificationTitle: qsTr("Transactions")
            onCopyNotificationMsg: qsTr("txid copied to clipboard")
        }

        // Confirmations
        TextEditWithTitle
        {
            title: qsTr("Confirmations")
            text: !details ? "" : details.confirmations
        }

        // Block Height
        TextEditWithTitle
        {
            title: qsTr("Block Height")
            text: !details ? "" : details.blockheight
        }

        AddressList
        {
            title: qsTr("From")
            model: !details ? [] : details.from
        }

        AddressList
        {
            title: qsTr("To")
            model: !details ? [] : details.to
        }

        // Notes
        TextAreaWithTitle
        {
            id: notes

            property string prev_text: ""

            title: qsTr("Notes")
            remove_newline: false
            field.text: !details ? "" : details.transaction_note
            saveable: true

            field.onTextChanged:
            {
                if (field.text.length > 500) field.text = prev_text
                else prev_text = field.text
            }

            onSaved: details.transaction_note = field.text
        }

        // Buttons
        footer:
        [
            DexButton
            {
                Layout.fillWidth: true
                text: qsTr("Close")
                leftPadding: 40
                rightPadding: 40
                radius: 18
                onClicked: root.close()
            },
            DexAppOutlineButton
            {
                Layout.fillWidth: true
                text: qsTr("View on Explorer")
                leftPadding: 40
                rightPadding: 40
                radius: 18
                onClicked: General.viewTxAtExplorer(api_wallet_page.ticker, details.tx_hash, false)
            }
        ]
    }
}
