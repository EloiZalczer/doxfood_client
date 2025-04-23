import 'package:doxfood/models.dart';
import 'package:doxfood/pages/map/tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelWidet extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidet({
    super.key,
    required this.controller,
    required this.panelController,
  });

  void togglePanel() {
    panelController
            .isPanelOpen // FIXME why is the panel never open ??
        ? panelController.close()
        : panelController.open();
  }

  Widget buildDragHandle() {
    return GestureDetector(
      onTap: togglePanel,
      child: Center(
        child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        buildDragHandle(),
        SizedBox(height: 36),
        Expanded(
          child: Consumer<PlacesModel>(
            builder: (context, model, child) {
              return model.places.isNotEmpty
                  ? ListView.builder(
                    controller: controller,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: model.places.length,
                    itemBuilder: (context, index) {
                      return PlaceTile(place: model.places[index]);
                    },
                  )
                  : Center(child: Text("No places"));
            },
          ),
        ),
      ],
    );
  }
}
